# frozen_string_literal: true

RSpec.describe Utility::ClassCollector do
  describe '.all_classes_under' do
    context 'when the module contains only classes' do
      it 'returns all classes directly defined in the module' do
        foo = Class.new
        bar = Class.new
        test_module = stub_const('TestModule', Module.new)
        stub_const('TestModule::Foo', foo)
        stub_const('TestModule::Bar', bar)

        expect(described_class.all_classes_under(mod: test_module)).to contain_exactly(foo, bar)
      end
    end

    context 'when the module contains nested modules with classes inside' do
      it 'recurses into nested modules and collects classes at every level' do
        top = Class.new
        deep = Class.new
        deepest = Class.new

        test_module = stub_const('TestModule', Module.new)
        stub_const('TestModule::Top', top)
        stub_const('TestModule::Inner', Module.new)
        stub_const('TestModule::Inner::Deep', deep)
        stub_const('TestModule::Inner::InnerMost', Module.new)
        stub_const('TestModule::Inner::InnerMost::Deepest', deepest)

        expect(described_class.all_classes_under(mod: test_module)).to contain_exactly(top, deep, deepest)
      end
    end

    context 'when the module contains constants that are neither classes nor modules' do
      it 'silently skips non-class, non-module constants' do
        foo = Class.new
        test_module = stub_const('TestModule', Module.new)
        stub_const('TestModule::Foo', foo)
        stub_const('TestModule::SOME_STRING', 'not a class or module')
        stub_const('TestModule::SOME_NUMBER', 42)
        stub_const('TestModule::SOME_ARRAY', [1, 2, 3].freeze)

        expect(described_class.all_classes_under(mod: test_module)).to contain_exactly(foo)
      end
    end

    context 'when the module contains no classes or modules at all' do
      it 'returns an empty array' do
        test_module = stub_const('TestModule', Module.new)
        stub_const('TestModule::SOME_VALUE', 'nothing else here')

        expect(described_class.all_classes_under(mod: test_module)).to eq([])
      end
    end

    context 'when a class is nested inside another class (not a module)' do
      it 'collects the outer class but does not recurse into it to find nested classes' do
        inner = Class.new
        test_module = stub_const('TestModule', Module.new)
        outer = stub_const('TestModule::Outer', Class.new)
        stub_const('TestModule::Outer::Inner', inner)

        result = described_class.all_classes_under(mod: test_module)

        expect(result).to contain_exactly(outer)
        expect(result).not_to include(inner)
      end
    end

    context 'when the module has both nested modules and non-module/class constants mixed together' do
      it 'collects classes from every level while ignoring unrelated constants' do
        top_level = Class.new
        nested = Class.new

        test_module = stub_const('TestModule', Module.new)
        stub_const('TestModule::TopLevel', top_level)
        stub_const('TestModule::IGNORED', :ignored)
        stub_const('TestModule::Sub', Module.new)
        stub_const('TestModule::Sub::Nested', nested)

        expect(described_class.all_classes_under(mod: test_module)).to contain_exactly(top_level, nested)
      end
    end
  end
end
