# frozen_string_literal: true

module Kernel
  class PrettyPrinter
    def pretty_print(tree)
      envelope do
        pretty_print_recursive(tree)
      end
    end

    def envelope(&block)
      5.times { puts }
      yield(block)
      5.times { puts }
    end

    def pretty_print_recursive(current_node, base_output = '')
      nodes_amount = current_node.nodes.count
      current_node.nodes.each_with_index do |node, index|
        next print_leaf(base_output, node.key, node.nodes[0]) if node.leaf?
        print_composite(base_output, node.key, nodes_amount, index) if node.composite?
        pretty_print_recursive(node, format_base_output(base_output, nodes_amount, index))
      end
    end
%{

h = Hasher.new
h.a.b.c.d.e = 5
h.lat.lng.mandatory = 'coooool'
h.figure.it.out = {a: 1}
h.__pretty_print

t = h.__tree

__tree__h_a_b = t.nodes[0].nodes[0]
__tree__h_lat = t.nodes[1]
__tree__h_lat_lng = t.nodes[1].nodes[0]
__tree__h_lat_lng.type = Kernel::TYPES::TREE::TYPE_COMPOSITE

__tree__h_a_b.nodes << Kernel::Tree.new(type: Kernel::TYPES::TREE::TYPE_COMPOSITE, root: t.root, key: :dolor)
__tree__h_lat.nodes << Kernel::Tree.new(type: Kernel::TYPES::TREE::TYPE_COMPOSITE, root: t.root, key: :sit)
__tree__h_lat_lng.nodes << Kernel::Tree.new(type: Kernel::TYPES::TREE::TYPE_COMPOSITE, root: t.root, key: :amet)

h.__pretty_print


t.nodes << Kernel::Tree.new(type: Kernel::TYPES::TREE::TYPE_COMPOSITE, root: t.root, key: :lexus)
}

    def format_base_output(base_output, nodes_amount, current_node_index)
      return "#{base_output}   " if nodes_amount == 1 || current_node_index == nodes_amount - 1
      return "#{base_output}#{pattern_branch_empty_last}" if current_node_index == nodes_amount - 1
      "#{base_output}#{pattern_branch_empty_not_last}"
    end

    def last?(nodes_amount, current_node_index)
      current_node_index == nodes_amount - 1
    end

    def print_composite(base_output, key, nodes_amount, current_node_index)
      return puts "#{base_output}#{pattern_branch_ramificating_last}#{pattern_key(key)}" if last?(nodes_amount, current_node_index)
      puts "#{base_output}#{pattern_branch_ramificating}#{pattern_key(key)}"
    end

    def print_leaf(base_output, key, value)
      puts "#{base_output}#{pattern_branch_ramificating_last}#{pattern_key(key)}#{pattern_value(value)}"
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

    def pattern_branch_empty_not_last
      '|  '
    end

    def pattern_branch_ramificating
      '|--'
    end

    def pattern_branch_ramificating_last
      '`--'
    end

    def pattern_composite_node(key)
      put key
    end

    def count_leafs(current_node)
      count_leafs_recursive(current_node)
    end

    def count_leafs_recursive(current_node)
      return 1 if current_node.leaf?
      result = 0
      current_node.nodes.each do |node|
        result += count_leafs_recursive(node)
      end
      result
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
