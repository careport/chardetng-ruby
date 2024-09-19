# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "rb_sys/extensiontask"

task build: :compile

GEMSPEC = Gem::Specification.load("char_det_ng.gemspec")

RbSys::ExtensionTask.new("char_det_ng", GEMSPEC) do |ext|
  ext.lib_dir = "lib/char_det_ng"
end

task default: %i[compile test]
