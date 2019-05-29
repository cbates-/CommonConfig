
Function NBAMailer 
<# This is a simple function that that sends a message.
The variables defined below can be passed as parameters by taking them out 
and putting then in the parenthesis above.

i.e. "Function Mailer ($subject)"

#>

{
    [CmdletBinding()]

        param(

                [Parameter( Mandatory=$true)]
                [String[]]
                $To = ( "cbates@nationallifegroup.com" ),

                <#
                [Parameter( Mandatory=$false)]

                [String[]]

                $CcRecipients,
                 #>
                 
                 # [Parameter( Mandatory=$false)]
                 
                 # [String[]]
                 
                 # $BccRecipients,                    



        [Parameter( Mandatory=$true)]
            [String]
            $Subject,



        [Parameter( Mandatory=$false)]
            [String]
            $Body



         # [Parameter( Mandatory=$false)]
         # [Switch]
         # $BodyAsHtml,                     


         # [Parameter( Mandatory=$true)]
         # [System.Management.Automation.PSCredential]
         # $Credential
        )

            $emailFrom = "cbates@nationallifegroup.com"
             # $subject="BlatherSkite"
             # NLGPPTVMBX61.corp.nlg.net
            $smtpserver="NLGPPTVMBX61.corp.nlg.net"
            $smtp=new-object Net.Mail.SmtpClient($smtpServer)
            $smtp.Send($emailFrom, $To, $Subject, $Body)
}
