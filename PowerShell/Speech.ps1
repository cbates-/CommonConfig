add-type -AssemblyName System.Speech


$talk = New-Object System.Speech.Synthesis.SpeechSynthesizer
$talk

$talk.Speak("Proc Zero Seven       disconnected")

$names = ($Talk.GetInstalledVoices().VoiceInfo.Name)
$names

