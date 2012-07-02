# Ruby 

class XSDInfoRuby < XSDInfo

  def output_to_xml_method_sequence(seq)

    puts "  def to_xml(inscope_ns, indent, io)"

    seq.choice.each do |member|
      case member._option
      when :element
        elem = member.element
        if is_multiples?(elem)
          puts "    @#{elem._member_name}.each do |i|"
          vname = 'i'
        else
          puts "    m = @#{elem._member_name}"
          puts "    if m"
          vname = 'm'
        end
        if elem._class_module == 'XSDPrimitives' && elem._class_name == 'string'
          puts "      XSDPrimitives.primitive_to_xml(#{elem._member_module}::NAMESPACE, '#{elem._name}', #{vname}, indent, io)"
        else
          puts "      #{vname}.to_xml(#{elem._member_module}::NAMESPACE, '#{elem._name}', inscope_ns, indent, io)"
        end
        puts "    end"

      when :sequence
        puts "    #{member.sequence._member_name}.to_xml(#{member.sequence._module_name}::NAMESPACE, '#{member.sequence._name}', inscope_ns, indent, io)"

      when :choice
        ch = member.choice
        if is_multiples?(ch)
          puts "    #{ch._member_name}.each do |i|"
          vname = 'i'
        else
          puts "    m =  #{ch._member_name}"
          puts "    if m"
          vname = 'm'
        end
        puts "      #{vname}.to_xml(inscope_ns, indent, io)"
        puts "    end"

      else
        raise 'internal error: invalid sequence'
      end
    end

    puts "  end"
  end

  def output_to_xml_method_choice(ch)

    puts "def to_xml(inscope_ns, indent, io)"
    puts "  case @_index"

    index = 0
    ch.choice.each do |item|
      puts "  when #{index}"
      case item._option

      when :element
        elem = item.element
        if is_multiples?(elem)
          puts "    @#{elem._member_name}.each do |i|"
        else
          puts "    i =  #{elem._member_name}"
          puts "    if i"
        end
        if elem._class_module == 'XSDPrimitives' && elem._class_name == 'string'
          puts "      XSDPrimitives.primitive_to_xml(#{item.element._member_module}::NAMESPACE, '#{item.element._name}', i, indent, io)"
        else
          puts "      i.to_xml(#{item.element._member_module}::NAMESPACE, '#{item.element._name}', inscope_ns, indent, io)"
        end
        puts "    end"

      when :sequence
        puts "    #{member.sequence._member_name}.to_xml(inscope_ns, indent, io)"
      when :choice
        puts "    #{member.choice._member_name}.to_xml(inscope_ns, indent, io)"
      else
        raise 'internal error: invalid choice'
      end

      index += 1
    end

    puts "  end"
    puts "end"
  end

  def output_to_xml_method_complexType(ct)

    puts <<"END"
    def to_xml(element_namespace, element_name, inscope_ns, indent, io)

      if inscope_ns.include?(element_namespace)
        # Namespace is already in scope, get the prefix for it
        prefix = inscope_ns[element_namespace]

        new_inscope_ns = inscope_ns
        ns_def = ''

      else
        # Namespace is not in scope, add it
        if inscope_ns.empty?
          prefix = nil
        else
          count = 0
          begin
            prefix = "n#\{count}"
          end while inscope_ns.include?(prefix)
        end

        new_inscope_ns = {}
        new_inscope_ns.replace(inscope_ns)
        new_inscope_ns[element_namespace] = prefix

        if prefix
          ns_def = " xmlns:#\{p}=\\\"#\{element_namespace}\\\""
        else
          ns_def = " xmlns=\\\"#\{element_namespace}\\\""
        end
      end
      if prefix
        qualifier = "\#{prefix}:"
      else
        qualifier = ''
      end

      if indent
        io.print indent
      end
      io.print "<#\{qualifier}#\{element_name}#\{ns_def}"
END

      # Output code for the attributes and attributeGroups

      if ct._form == :complexType_simpleContent
        # Attributes from the simpleContent

        ct.choice1.simpleContent.extension.attribute.each do |attr|
          puts "      if @#{attr._member_name}"
          puts "        io.print ' #{attr.name}=\"'"
          puts "        io.print XSDPrimitives.pcdata(@#{attr._member_name})"
          puts "        io.print '\"'"
          puts "      end"
        end
      end

      ct.choice2.each do |a_or_ag|
        case a_or_ag._option
        when :attribute
          attr = a_or_ag.attribute
          puts "      if #{attr._member_name}"
          puts "        io.print \" #{attr.name}=\\\"\""
          puts "        io.print XSDPrimitives.pcdata(@#{attr._member_name})"
          puts "        io.print '\"'"
          puts "      end"

        when :attributeGroup
        else
          raise 'internal error'
        end
      end

      # Complete the start tag (or empty tag)

      if ct._form != :complexType_empty
        puts "      io.print \'>\'"
        puts
        puts "      if indent"
        puts "        nested_indent = indent + '  '"
        puts "      else"
        puts "        nested_indent = nil"
        puts "      end"

      else
        puts "      io.print '/>'"
      end

      if ct._form != :complexType_simpleContent
        puts "      io.puts"
      end

      # Output code for the content model

      case ct._form
      when :complexType_simpleContent
        puts "      if @_value"
        puts "        io.print XSDPrimitives.cdata(@_value)"
        puts "      end"
      when :complexType_sequence
        puts "      _sequence.to_xml(new_inscope_ns, nested_indent, io)"

      when :complexType_choice
        if is_multiples?(ct.choice1.choice)
          puts "      _choices.each do |i|"
        else
          puts "      i = _choice"
          puts "      if i"
        end
        puts "        i.to_xml(new_inscope_ns, nested_indent, io)"
        puts "      end"

      when :complexType_empty
        # no content model

      else
        raise "internal error: #\{ct._form}"
      end

      if ct._form != :complexType_empty
        # Code to output the end tag

        if ct._form != :complexType_simpleContent
          puts "      if indent"
          puts "        io.print indent"
          puts "      end"
        end

    puts <<"END"
      io.print "</#\{qualifier}#\{element_name}>"
      if indent
        io.puts
      end
END
      end
      puts "    end"
  end

end
