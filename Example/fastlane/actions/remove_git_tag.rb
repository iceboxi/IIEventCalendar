module Fastlane
  module Actions
    module SharedValues
      REMOVE_GIT_TAG_CUSTOM_VALUE = :REMOVE_GIT_TAG_CUSTOM_VALUE
    end

    class RemoveGitTagAction < Action
      def self.run(params)
        command = []

        target_tag = params[:tag]
        remove_local = params[:remove_local]
        remove_remote = params[:remove_remote]

        command << "git tag -d #{target_tag}" if remove_local
        command << "git push origin :#{target_tag}" if remove_remote

        if command.empty?
          UI.message('👉 If you really want to delete a tag, you should to set up remove_local and remove_remote at least one for true!')
        else
          result = command.join(' & ')
          Actions.sh(result)
          UI.message('Remove git tag Successfully! 🎉')
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Remove git tag"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "Remove the local tag or remote tag for a git repertory"
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :tag,
                                       description: 'The tag to delete',
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :remove_local,
                                       description: 'If delete local tag',
                                       is_string: false,
                                       optional: true,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :remove_remote,
                                       description: 'If delete remote tag',
                                       is_string: false,
                                       optional: true,
                                       default_value: true)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['REMOVE_GIT_TAG_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["ice"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end

      def self.example_code
        [
          'remove_git_tag(tag: "0.1.0") # Delete both local tag and remote tag',
          'remove_git_tag(tag: "0.1.0", remove_local: false) # Only delete remote tag',
          'remove_git_tag(tag: "0.1.0", remove_remote: false) # Only delete local tag'
        ]
      end

      def self.category
        :source_control
      end
    end
  end
end
