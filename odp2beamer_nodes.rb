module Odp2Beamer
  
  module OdpFile
    def value(env = {})
      tag.value
    end
  end
  
  module Tag
    def value(env = {})
      "#{tag_open.value}#{content.value}#{tag_close.value}"
    end
  end

  module TagTagOpenClose
    def value(env = {})
      ''
    end
  end

  module TagOpenCloseWithAttribs
    def value(env = {})
      tagname.text_value
    end
  end

  module TagOpenCloseWithoutAttribs
    def value(env = {})
      tagname.text_value
    end
  end

  module ContentTagContent
    def value(env = {})
      "#{tag.value}#{content.value}"
    end
  end
  
  module ContentTag
    def value(env = {})
      tag.value
    end
  end
  
  module ContentRegExp
    def value(env = {})
      text_value
    end
  end
  
  module TagOpen
    def value(env = {})
      case tagname.text_value
      when 'office:presentation':
          "\n\\begin{document}"
      when 'draw:page':
          "\n\\begin{frame}"
      when 'text:list':
          "\n\\begin{enumerate}"
      when 'text:list-item':
          "\n\\item "
      when 'draw:image':
          "\n\\begin{figure}" <<
          "\n\\centering" <<
          "\n\\includegraphics{" <<
          attributes.value['xlink:href'] <<
          '}' <<
          "\n\\caption{TODO:change me}" <<
          "\n\\label{fig:change_me}"
      when 'text:p'
        parent_tag_name = self.parent.parent.parent.elements[0].elements[1].text_value
        case parent_tag_name
        when 'text:list-item':
          ''
        when 'draw:text-box'
          "\n\\frametitle{"
        end
      when 
        'office:document-content', 
        'office:body', 
        'style:style', 
        'office:automatic-styles', 
        'office:scripts', 
        'text:list-style', 
        'text:list-level-style-bullet', 
        'presentation:notes', 
        'draw:frame', 
        'draw:text-box', 
        'draw:framepresentation:notes':
          ''
      else
        "\nTODO-BEGIN[#{tagname.text_value}]"
      end
    end
  end

  module TagClose
    def value(env = {})
      case tagname.text_value
      when 'office:presentation':
          "\n\\end{document}"
      when 'draw:page':
          "\n\\end{frame}"
      when 'text:list':
          "\n\\end{enumerate}"
      when 'draw:image':
          "\n\\end{figure}"
      when 'text:list-item':
          ''
      when 
        'office:document-content', 
        'office:body', 
        'style:style', 
        'office:automatic-styles', 
        'office:scripts', 
        'text:list-style', 
        'text:list-level-style-bullet', 
        'presentation:notes', 
        'draw:frame', 
        'draw:text-box', 
        'draw:framepresentation:notes':
          ''
      when 'text:p'
        parent_tag_name = self.parent.parent.parent.elements[0].elements[1].text_value
        case parent_tag_name
        when 'text:list-item':
          ''
        when 'draw:text-box'
          '}'
        end
      else
        "\nTODO-END[#{tagname.text_value}]"
      end
    end 
  end
  
  module OneAttribute
    def value(env = {})
      attribute.value
    end
  end
  
  module MoreThanOneAttribute
    def value(env = {})
      attributes.value.merge(attribute.value)
    end
  end
  
  module Attribute
    def value(env = {})
      {tagname.text_value => attribute_value.value}
    end
  end
  
  module AttributeValue
    def value(env = {})
      text_value
    end
  end
end
