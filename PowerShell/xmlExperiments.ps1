# From: http://blogs.technet.com/b/heyscriptingguy/archive/2014/06/13/calling-xmldocument-methods-in-powershell.aspx
[xml]$xmldocument = Get-Content .\books.xml
# $xmldocument.ChildNodes.selectNodes("*")
$xmldocument.ChildNodes.selectNodes("*/title")
$xmldocument.ChildNodes.selectNodes("*/genre") | select '#text' –Unique
$xmldocument.ChildNodes.SelectNodes("*/price") | measure '#text' –Sum

# Add a new item
$copy = $xmldocument.catalog.book[0].Clone()
$copy.id = 'bk113'
$copy.author = 'Wilson, Ed'
$copy.title = 'Windows PowerShell Best Practices'
$copy.price = '59.99'
$copy.publish_date = '2014-01-25'
$copy.description = 'Automate system administration using Windows PowerShell best practices’
$xmldocument.catalog.appendchild($copy)
$xmldocument.ChildNodes.childnodes

# Now I write the InnerXML to a text file with the XML extension:
$xmldocument.InnerXml >>.\modified.xml
