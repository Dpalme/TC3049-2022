# Template and implementations of the template
# Date: 03-Mar-2022
# Authors:
#          A01747290 Diego Palmerin
#          A01748354 Fernando Melgar

# Factory methods for creating tables
class TableGenerator
  def initialize(header, data)
    @header = header
    @data = data
  end

  # Generates the table
  def generate
    generate_header_row + (@data.map { |x| generate_row(x) }).join
  end

  # Default header row generator
  def generate_header_row
    (@header.map { |x| generate_header_item(x) }).join
  end

  # Default item generator
  def generate_item(item)
    item
  end

  # Default row generator
  def generate_row(row)
    (row.map { |x| generate_item(x) }).join
  end

  # Default header item
  def generate_header_item(item)
    item
  end
end

# A class to generate CSV tables
class CSVTableGenerator < TableGenerator

  # Override to join items with ","
  def generate_row(row)
    "#{(row.map { |x| generate_item(x) }).join(",")}\n"
  end

  # In CSV the first line defaults as header
  # no special format is needed
  def generate_header_row
    generate_row(@header)
  end
end

# A class to generate HTML tables
class HTMLTableGenerator < TableGenerator

  # Override to wrap items as <tr>$1</tr>
  def generate_row(row)
    "<tr>#{(row.map { |x| generate_item(x) }).join("")}</tr>\n"
  end

  # Override to wrap item as <td>$1</td>
  def generate_item(item)
    "<td>#{item}</td>"
  end

  # Override to wrap items as <tr>$1</tr>
  def generate_header_row
    "<tr>#{(@header.map { |x| generate_header_item(x) }).join("")}</tr>\n"
  end

  # Override to wrap item as <th>$1</th>
  def generate_header_item(item)
    "<th>#{item}</th>"
  end

  # Override of default generate to add closing |=====
  def generate
    "<table>\n" +
    generate_header_row +
    (@data.map { |x| generate_row(x) }).join +
    "</table>\n"
  end
end

# A class to generate ASciiDoc tables
class AsciiDocTableGenerator < TableGenerator

  # Override to create necessary lines and join headers
  def generate_header_row
    "|#{(@header.map { |x| generate_header_item(x) }).join("|")}\n"
  end

  # Override to join items in |$1|$2|$3 format
  def generate_row(row)
    "|#{(row.map { |x| generate_item(x) }).join("|")}\n"
  end

  # Override of default generate to add closing |=====
  def generate
    "[options=\"header\"]\n" +
    "|==========\n" +
    generate_header_row +
    (@data.map { |x| generate_row(x) }).join +
    "|==========\n"
  end
end
