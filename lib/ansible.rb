module Ansible
  def escape_to_html(data)
    data = span(true, "none") + data.gsub(/\0/, '')
    data.gsub!(/\e\[0?m/, span(false, "none"))
    data.gsub!(/\e\[([0-9;]+)m/) { |match|
      span(false, *$1.split(';'))
    }
    data + "</span>"
  end

  def strip_escapes(string)
    string.gsub!(/\e\[(\d;)?\d*m/, "")
    string
  end

  def ansi_escaped(string, maxlen=65535)
    return '' unless string
    if string.size < maxlen
      z = escape_to_html(string)
    else
      z = strip_escapes(string.to_s)
    end
    z
  end

  private
    def span(first, *codes)
      s = first ? "" : "</span>"

      if codes.include?("none")
        classes = ["ansible_none"]
      else
        classes = codes.reject{|c| c.to_i == 0}.map{|c| "ansible_#{c.to_i}"}
      end

      s += %Q{<span class="#{classes.join(" ")}">}
      s
    end
end
