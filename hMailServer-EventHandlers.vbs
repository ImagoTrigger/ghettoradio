'   Sub OnClientConnect(oClient)
'   End Sub

'   Sub OnSMTPData(oClient, oMessage)
'   End Sub

'   Sub OnAcceptMessage(oClient, oMessage)
'   End Sub

'   Sub OnDeliveryStart(oMessage)
'   End Sub

  Sub OnDeliverMessage(oMessage)
	Set fso = CreateObject("Scripting.FileSystemObject")
	If (fso.FileExists("D:\security.disarmed")) Then
	   Result.Value = 1 
	Else
	   Result.Value = 0
	End If  
   End Sub

'   Sub OnBackupFailed(sReason)
'   End Sub

'   Sub OnBackupCompleted()
'   End Sub

'   Sub OnError(iSeverity, iCode, sSource, sDescription)
'   End Sub

'   Sub OnDeliveryFailed(oMessage, sRecipient, sErrorMessage)
'   End Sub

'   Sub OnExternalAccountDownload(oFetchAccount, oMessage, sRemoteUID)
'   End Sub

Sub Speak(oMessage)
	Wait(1)
End Sub

Function Wait(sec)
   With CreateObject("WScript.Shell")
      .Run "powershell New-Item D:\front.txt -type file", 0, True
   End With
End Function