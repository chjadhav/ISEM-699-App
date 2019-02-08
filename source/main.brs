' ********** Copyright 2015 Roku Corp.  All Rights Reserved. ********** 
Library "Roku_Ads.brs"

sub RunUserInterface(args As Dynamic)
  m.screen = CreateObject("roSGScreen")
  m.global = m.screen.getGlobalNode()
  createGlobalVariables()

  'load config, categories And Dictionary file
  if initPrefixes("file://pkg:/data/config.json") = -1 or initCategories() = -1 or initDictionary() = -1 then
    showErrorScene()
  else
    loadMenuCategories(m.global.categories)
    loadAppData(args)
    '----------------------- |APP Specefic| ------------------
    m.global.bustCache = false
    '----------------------- |APP Specefic| ------------------
    setHomeScene()
  end if

  while true
    msg = wait(0, m.port) 'Wait for incoming Messages from the Port
    print msg
    if type(msg) = "roSystemLogEvent" then
      i = msg.GetInfo()
      print "********* SYSTEM MSG *********"
      print i
      print "********* SYSTEM MSG END *********"
      if i.LogType = "bandwidth.minute"
        print "bandwidth: " i.bandwidth
        m.global.bandwidth = i.bandwidth
      end if

    else if type(msg) = "roSGScreenEvent"
      if msg.isScreenClosed() then return
    
    else if type(msg) = "roSGNodeEvent"

      if msg.GetField() = "exitApp" and msg.GetData() = true then
        showExitConfirmationDialog()

      else if msg.GetField() = "buttonSelected"
        if msg.GetData() = 0 then
          exit while
        else
           m.scene.dialog.close = true
        end if

      else if msg.GetField() = "wasClosed"
        exit while
      end if
    end if
  end while

  if m.screen <> invalid then
    m.screen.Close()
    m.screen = invalid
  end if
  exitChannel:
end sub 

