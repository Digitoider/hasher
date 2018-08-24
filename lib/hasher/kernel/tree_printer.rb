# frozen_string_literal: true

module Kernel
  # TODO: Configuration:
  # key_value_separator: String
  # symbols_per_node: Number

  class TreePrinter
    attr_reader :result

    def initialize
      @result = []
    end

    def print(tree)
      reset_result!
      build_result!(tree)
      result.each { |str| puts str }
    end

    def build_result!(tree)
      @result << tree.key
      build_result_recursive!(tree)
      @result
    end

    def reset_result!
      @result = []
    end

    protected

    def build_result_recursive!(current_node, base_output = '')
      nodes_amount = current_node.nodes.count
      current_node.nodes.each_with_index do |node, index|
        next @result << get_leaf(base_output, node.key, node.nodes[0]) if node.leaf?
        @result << get_composite(base_output, node.key, nodes_amount, index) if node.composite?
        build_result_recursive!(node, format_base_output(base_output, nodes_amount, index))
      end
    end

    def format_base_output(base_output, nodes_amount, current_node_index)
      return "#{base_output}   " if nodes_amount == 1 || current_node_index == nodes_amount - 1
      return "#{base_output}#{pattern_branch_empty_last}" if current_node_index == nodes_amount - 1
      "#{base_output}#{pattern_branch_empty_intermediate}"
    end

    def last?(nodes_amount, current_node_index)
      current_node_index == nodes_amount - 1
    end

    def get_composite(base_output, key, nodes_amount, current_node_index)
      return "#{base_output}#{pattern_branch_ramificating_last}#{pattern_key(key)}" if last?(nodes_amount, current_node_index)
      "#{base_output}#{pattern_branch_ramificating_intermediate}#{pattern_key(key)}"
    end

    def get_leaf(base_output, key, value)
      "#{base_output}#{pattern_branch_ramificating_last}#{pattern_key(key)}#{pattern_value(value)}"
    end

    def pattern_key(key)
      "#{key}"
    end

    def pattern_value(value)
      ": #{value}"
    end

    def print_s(base_output = '')
      puts "#{base_output}|--"
    end

    def pattern_branch_empty_last
      '+--'
    end

    def pattern_branch_empty_intermediate
      '|  '
    end

    def pattern_branch_ramificating_intermediate
      '|--'
    end

    def pattern_branch_ramificating_last
      '`--'
    end
  end
end

%{
etc
|-- abrt
|   |-- abrt-action-save-package-data.conf
|   |-- abrt.conf
|   |-- gpg_keys
|   `-- plugins
|       |-- CCpp.conf
|       `-- python.conf
|-- acpi
|   |-- actions
|   |   `-- power.sh
|   `-- events
|       |-- power.conf
|       `-- video.conf
|-- adjtime
|-- aliases
|-- aliases.db
|-- alsa
|   `-- alsactl.conf
|-- alternatives
|   |-- links -> /usr/bin/elinks
|   |-- links-man -> /usr/share/man/man1/elinks.1.gz
|   |-- mta -> /usr/sbin/sendmail.postfix
|   |-- mta-aliasesman -> /usr/share/man/man5/aliases.postfix.5.gz
|   |-- mta-mailq -> /usr/bin/mailq.postfix
|   |-- mta-mailqman -> /usr/share/man/man1/mailq.postfix.1.gz
|   |-- mta-newaliases -> /usr/bin/newaliases.postfix
|   |-- mta-newaliasesman -> /usr/share/man/man1/newaliases.postfix.1.gz
|   |-- mta-pam -> /etc/pam.d/smtp.postfix
|   |-- mta-rmail -> /usr/bin/rmail.postfix
|   |-- mta-sendmail -> /usr/lib/sendmail.postfix
|   `-- mta-sendmailman -> /usr/share/man/man1/sendmail.postfix.1.gz
|-- anacrontab
|-- asound.conf
|-- at.deny
|-- audisp
|   |-- audispd.conf
|   `-- plugins.d
|       |-- af_unix.conf
|       |-- sedispatch.conf
|       `-- syslog.conf
|-- audit
|   |-- auditd.conf
....
..
..
|-- xinetd.d
|   `-- rsync
|-- xml
|   `-- catalog
|-- yum
|   |-- pluginconf.d
|   |   |-- product-id.conf
|   |   |-- protectbase.conf
|   |   |-- rhnplugin.conf
|   |   `-- subscription-manager.conf
|   |-- protected.d
|   |-- vars
|   `-- version-groups.conf
|-- yum.conf
`-- yum.repos.d
    |-- epel.repo
    |-- epel-testing.repo
    |-- ksplice-uptrack.repo
    |-- redhat.repo
    `-- rhel-source.repo

}
