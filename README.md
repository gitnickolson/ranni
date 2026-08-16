<div align="center">
  <h1 style="margin-bottom: 0; padding-bottom: 0">Ranni the Witch</h1>
  <img style="margin-top: 0; padding-top: 0" src="dark_moon_ring.png" />
</div>

Ranni is a self-hostable, general-purpose Discord bot written in Ruby using the [discordrb](https://github.com/shardlab/discordrb) library.

It supports administrative commands, text- and voice-leveling, event reactions like welcome messages, and general information about various things (e.g. `/userinfo` to get info about a user, or `/serverinfo` to get info about a Discord server). There's a bit more to it, but you can check out all the existing commands with `/help`.

## How to self-host Ranni

The following steps might be useful if you want to host Ranni yourself - on a private server, an old laptop, or your own PC.

### Adding Ranni to your server

First, head to the [Discord Developer Portal](https://discord.com/developers/home) and go to the "Applications" tab. Create a new application and name it whatever you want (preferably Ranni :P).

Go to your newly created app and open the "OAuth2" tab. Scroll down to the OAuth2 URL Generator and check the "bot" box. A "Bot Permissions" widget will open - select "Administrator" and copy the generated link further down below.

Paste that link into your browser's address bar. Discord will then prompt you to authorize and select the server the bot should be added to.

### Cloning the repository

You'll also need the code on your machine. First, [install git](https://git-scm.com/install/) if you haven't already.

Then open a terminal and clone the repository into your current directory:

```sh
git clone https://github.com/gitnickolson/ranni.git
```

You might as well want to create a dedicated folder first and clone the code into that:

```sh
# after creating a folder
cd your_path/to_your_folder/folder_name

git clone https://github.com/gitnickolson/ranni.git
```

### Generating a token

On the Discord Developer Portal, go to your application and open the "Bot" tab. You'll find a "Reset Token" button there - click it and copy the freshly generated token.

Inside the directory you just cloned, create a file called `.env.test` and add your token to it:

```sh
TOKEN="your_token"
```

### Setting up Ranni's database

In this step, you'll set up a database. It runs in a local database server, which needs some configuration data first. Add the following lines to your `.env.test` file:

```sh
POSTGRES_DB="ranni_db"
POSTGRES_USER="admin"
POSTGRES_PASSWORD="admin"
POSTGRES_URL="postgres://admin:admin@localhost:5432/ranni_db"
```

> ⚠️ **NOTE:** Don't use such simple login data on an important production database :)

Now for the slightly trickier part - you'll need to [install Docker](https://docs.docker.com/desktop/) to run the database server.

Once that's done, open another terminal and run:

```sh
# if not already inside your directory
cd your_path/to_your_folder/folder_name/ranni

docker compose up -d
```

This sets up and starts your database server inside a Docker container.

Next, create the actual database by running the following from within the `ranni` directory:

```sh
bundle exec rake db:create db:migrate
```

It should output the following:

```
Database ranni_db successfully created
Migrating to latest
Database ranni_db successfully migrated
```

### Starting Ranni

Now that your local database is set up, it's time to start the bot:

```sh
bundle exec bin/ranni
```

And that should be it!

## How to add a new command

I've built a framework that makes adding new commands a lot simpler. The amount of work involved depends on what you're trying to do, though.

Documentation for any of the used discordrb library methods can be found in its [corresponding documentation](https://drb.shardlab.dev/v3.8.0/).

To add a command, create a Ruby file or a folder (depending on the command type - see below) named after the command inside the `./lib/commands/public` folder. If the command should only be accessible to admins or server boosters, place the file/folder inside `./lib/commands/administrator` or `./lib/commands/booster` instead.

### Adding a simple command (without subcommands)

Let's say you want to create a command called `/random_gif`. First, create a file called `random_gif.rb` in the folder matching the desired permission level.

Then create a new class named `RandomGif` inside that file. The class should inherit from `Command` and be nested inside modules matching the folder structure, since this project uses [zeitwerk](https://github.com/fxn/zeitwerk) for autoloading. If that doesn't quite click, just copy the structure of an existing command (e.g. `./lib/commands/public/userinfo`) as a starting point.

Your command class also needs to define `NAME` and `DESCRIPTION` constants. `NAME` should be a symbol and will be used by Discord to display the name of the command (so `:random_gif`, following the example above). `DESCRIPTION` is what Discord shows in the slash-command dropdown.

You'll then add a private `#command_action` method containing all of your command's logic.

If your command needs custom parameters, you'll also need to write a `.register` class method. You can find an example of this in `./lib/commands/public/userinfo`, which defines a custom `user` parameter that lets someone select a user when using the command on Discord.

Custom parameters can then be read from an options hash on the event object available inside each command instance - just call `event.options['your_custom_parameter_name']` from any instance method to access what the user entered.

### Adding a command with subcommands

Adding a command with subcommands works similarly to adding a simple command.

For these commands, create a folder named after your command (e.g. `game_info`) inside `./lib/commands/public` (or one of the other two permission-level folders). That folder needs two types of files:

1. The main command file (a Ruby file named `game_info.rb`, following the example above)
2. Files defining your subcommands (e.g. `lol.rb` and `valorant.rb`, if the command should return info on those specific games)

The main command file, `game_info.rb`, should then define a new class named `GameInfo`. This class should inherit from `ParentCommand` and be nested inside modules matching the folder structure, since this project uses [zeitwerk](https://github.com/fxn/zeitwerk) for autoloading. If that doesn't quite click, copy the structure of an existing command with subcommands (e.g. `./lib/commands/administrator/default_color/display_color.rb`) as a starting point.

Your command class needs to define `NAME`, `DESCRIPTION`, and `SUBCOMMANDS` constants. `NAME` should be a symbol and will be used by Discord to display the name of the command (so `:game_info`, following the example above). `DESCRIPTION` is what Discord shows in the slash-command dropdown. `SUBCOMMANDS` should be an array of the subcommand classes you'll create next. For the `GameInfo` example, it would look like this: `SUBCOMMANDS = [Lol, Valorant]`.

That's it for the main command class. Follow the same steps as before to create the subcommand classes: Create the corresponding Ruby files inside the `game_info` folder and define classes nested inside modules matching the folder structure. Subcommand classes should inherit from `Subcommand` instead of `ParentCommand`, unlike the main command class. They don't need a `SUBCOMMANDS` constant as well - just `NAME` and `DESCRIPTION`. Again, feel free to reference an existing command like in `./lib/commands/administrator/default_color` to see how the pieces fit together.

Each subcommand also needs a private `#command_action` instance method containing its logic.

If a subcommand needs custom parameters, write a `.register` class method for it, just like with simple commands. You can find an example in `./lib/commands/administrator/default_color/change.rb`, which defines a custom `color` parameter that lets someone enter a color code when using the command on Discord.

As before, custom parameters can be read via `event.options['your_custom_parameter_name']` from any instance method within the class.

## How to add a new database entity

If you're adding a bigger feature, you'll probably need to persist some data too - for example, if you added a custom minigame and wanted to store highscores. To do that, you'll need to add a new table to the Postgres database.

I'll keep this brief, since I'd expect anyone attempting this to already be fairly comfortable with how databases work. Here's a quick checklist:

1. Add a new migration file with a Sequel migration in `./migrations`. This defines your table structure.
2. Run `bundle exec rake db:migrate` to migrate your database.
3. Add a new file to `./lib/models` that defines your Sequel model.
4. Add a repository class that adds an abstraction layer to prevent direct access to the model.
5. Use your repository to access and modify entities from within your command handlers (at least for any commands that manipulate data).

For reference, check out the corresponding files (migration, model, repository) for the `Ranks` table and its entities. These are also manipulated via administrator commands, found in `./lib/commands/administrator/ranks`.
