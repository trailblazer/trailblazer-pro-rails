require "trailblazer/workflow"

module Trailblazer
  module Pro
    # FIXME: test me!
    class Discover < ::Rails::Generators::Base # FIXME: should be trailblazer:workflow:discover
      # source_root File.expand_path("templates", __dir__)
      argument :json_filename, type: :string, banner: "Filename of imported diagram.json"
      class_option :namespace, type: :string, banner: "Collaboration namespace constant"
      class_option :start_lane, type: :string, default: nil, banner: "Start activity"#, aliases: :start
      # argument :filename, type: :string, default: nil, banner: "Filename where to serialize the iterations"
      class_option :test, type: :string, default: nil, banner: "Filename for a spec"
      class_option :failure, type: :string, default: nil, banner: "Instruct discovery to run a segment of path again, with a failing task", repeatable: true

      def discover_from_schema_name
        namespace       = @options[:namespace]
        start_lane      = @options[:start_lane]
        failure_options = @options[:failure]
        test_filename   = @options[:test]


        # Posting::Collaboration::Schema  => schema
        # Posting::Collaboration          => namespace
        #
        # posting/collaboration/generated/posting-v1.json
        # posting/collaboration/generated/iteration_set.json
        # posting/collaboration/generated/state_table.rb
        # posting/collaboration/state_guards.rb                 # what you change

        states = Trailblazer::Workflow::Task::Discover.(
          json_filename:  json_filename,
          namespace:      namespace,
          target_dir:     File.join("app/concepts", namespace.to_s.underscore),
          start_lane:     start_lane,
          test_filename:  test_filename,
          dsl_options_for_run_multiple_times: Utils.translate_failure_option_for_run_multiple_times(failure_options),
        )

        puts "Discovered #{states.size} states."
      end

      module Utils
        module_function

        # --failure UI:Create,lifecycle:Create --failure blubb,yeah
        def translate_failure_option_for_run_multiple_times(failure_args)
          return {} unless failure_args

          failure_args.collect do |lane_task|
            lane_tuple, task_tuple = lane_task.split(",")

            [
              lane_tuple.split(":"),
              {ctx_merge: {task_tuple.to_sym => Trailblazer::Activity::Left}, config_payload: {outcome: :failure}}
            ]
          end.to_h
        end
      end
    end # Discover
  end
end
