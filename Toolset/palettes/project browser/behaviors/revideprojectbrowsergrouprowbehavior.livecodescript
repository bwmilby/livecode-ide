﻿script "revIDEProjectBrowserGroupRowBehavior"
on FillInData pDataA, pRow
   # Map pDataA values to physical controls...
   
   set the cRowNumber of me to pRow
   set the cIndent of me to pDataA["level"]-1
   set the cObjectLongID of me to pDataA["long id"]
   set the cBehaviorLongID of me to pDataA["behavior"]
   set the cLevelConnectors of me to pDataA["levels"]
   
   put pDataA["type"] & ":" into field "type" of me
   put pDataA["name"] into field "name" of me
   set the tooltip of field "name" of me to pDataA["long id"]
   
   set the backgroundColor of graphic "background" of me to empty
   
   if pDataA["scriptlines"] is 0 or pDataA["scriptlines"] is empty then
      put 0 into field "scriptLines" of me
   else
      put pDataA["scriptlines"] into field "scriptLines" of me
   end if 
   
   -- Behaviors
   if pDataA["behavior scriptlines"] is empty then
      repeat with i = 1 to 10
         hide grc ("behaviorScriptLines" & i) of me
      end repeat
   else
      
      # check parent behaviors
      local tTargetBehavior
      local tBehaviorList
      
      put pDataA["behavior"] into tTargetBehavior
      put tTargetBehavior & cr into tBehaviorList
      repeat
         put the behavior of tTargetBehavior into tTargetBehavior
         if tTargetBehavior <> "" then
            put tTargetBehavior & cr after tBehaviorList
         else
            exit repeat
         end if
      end repeat
      delete char - 1 of tBehaviorList -- return
      
      local tNoOfLInes
      local tCounter
      local tCPName
      
      put min(the number of lines of tBehaviorList, 10) into tNoOfLines
      repeat with i = 1 to tNoOfLines
         set the toolTip of grc ("behaviorScriptLines" & i) of me to line i of tBehaviorList
         show grc ("behaviorScriptLines" & i) of me
         put ("cBehaviorLongID" & i) into tCPName
         set the tCPName of me to line i of tBehaviorList
         put i into tCounter
      end repeat
      repeat with j = tCounter + 1 to 10
         hide grc ("behaviorScriptLines" & j) of me
      end repeat
   end if 
   
   if pDataA["childCount"] is empty or pDataA["childCount"] is 0  then 
      set the cState of group "disclosure" of me to "cantExpand"
      set the cIcon of group "disclosure" of me to "cantExpand"
      disable group "disclosure" of me 
   else
      if pDataA["expanded"] is true then
         set the cState of group "disclosure" of me to "expanded"
         set the cIcon of group "disclosure" of me to "childExpanded"
      else
         set the cState of group "disclosure" of me to "contracted"
         set the cIcon of group "disclosure" of me to "childContracted"
      end if
      enable group "disclosure" of me 
   end if
   
   ## Visibility
   if pDataA["visible"] is true then
      set the icon of button "visible" of me to the id of image "visible_on" of card "templates" of this stack
      set the tooltip of button "visible" of me to "Hide"
   else if pDataA["visible"] is false then
      set the icon of button "visible" of me to the id of image "visible_off" of card "templates" of this stack
      set the tooltip of button "visible" of me to "Show"
   end if  
   
   ## Can't select
   if pDataA["cantSelect"] is true then
      set the icon of button "cantSelect" of me to the id of image "cantSelect_on" of card "templates" of this stack
      set the tooltip of button "cantSelect" of me to "Hide"
   else if pDataA["cantSelect"] is false then
      set the icon of button "cantSelect" of me to the id of image "cantSelect_off" of card "templates" of this stack
      set the tooltip of button "cantSelect" of me to "Show"
   end if  
   
   if revIDEGetPreference("pb_indicator") is "text" then
      show field "type" of me
      hide image "groupIcon" of me
   else
      hide field "type" of me
      show image "groupIcon" of me
   end if
end FillInData


on LayoutControl pControlRect
   local tLevelConnectors, tConnectorCount, tLoc, tTextSize
   
   put the effective textSize of me into tTextSize
   
   put item 1 of the loc of me & comma & item 2 of the loc me -1 into tLoc
   put the cLevelConnectors of me into tLevelConnectors
   put the number of lines in the keys of tLevelConnectors into tConnectorCount
   
   # Resize controls/row   
   set the rect of graphic "background" of me to pControlRect
   set the width of graphic "bottom_border" of me to (item 3 of pControlRect - item 1 of pControlRect)+2
   set the bottomLeft of graphic "bottom_border" of me to item 1 of pControlRect-1, item 4 of pControlRect
   
   ## Set the formatted height of all the fields
   set the fixedLineHeight of field "type" of me to false
   set the fixedLineHeight of field "name" of me to false
   set the height of field "type" of me to the formattedHeight of field "type" of me
   set the height of field "name" of me to the formattedHeight of field "name" of me
   
   set the fixedLineHeight of field "scriptLines" of me to true
   set the textSize of field "scriptLines" of me to empty
   if tTextSize <=12 then
      set the textHeight of field "scriptLines" of me to (tTextSize + (tTextSize/2))
   else
      set the textHeight of field "scriptLines" of me to (tTextSize + (tTextSize/3))
   end if
   set the height of field "scriptLines" of me to the viewProp["row height"] of the owner of the owner of the owner of me - 6
   
   repeat with i = 1 to 10
      set the textSize of grc ("behaviorScriptLines" & i) of me to empty
      set the height of grc ("behaviorScriptLines" & i) of me to the viewProp["row height"] of the owner of the owner of the owner of me - 6
      set the width of grc ("behaviorScriptLines" & i) of me to tTextSize + 2
   end repeat
   
   set the loc of field "type" of me to tLoc
   set the loc of field "name" of me to tLoc
   set the loc of button "cantSelect" of me to tLoc
   set the loc of button "visible" of me to tLoc
   set the loc of field "scriptLines" of me to tLoc
   
   repeat with i = 1 to 10
      set the loc of grc ("behaviorScriptLines" & i) of me to tLoc
   end repeat
   
   set the width of field "scriptLines" of me to the formattedWidth of field "scriptLines" of me 
   set the width of field "name" of me to the formattedWidth of field "name" of me
   
   set the loc of field "type" of me to tLoc
   set the loc of field "name" of me to tLoc
   set the loc of button "cantSelect" of me to tLoc
   set the loc of button "visible" of me to tLoc
   set the loc of field "scriptLines" of me to tLoc
   set the loc of image "groupIcon" of me to tLoc
   
   ## Set the vertical location of the name and text fields
   if tTextSize <= 14 then
      set the top of field "name" of me to the top of me + 2
   else
      set the top of field "name" of me to the top of me
   end if
   set the top of field "type" of me to the top of field "name" of me
   
   connectorResize "disclosure"
   setConnectorIcon the long id of group "disclosure" of me, the cIcon of group "disclosure" of me
   repeat with x = 1 to 9
      if x > tConnectorCount then
         hide group ("connector" & x) of me
      else
         connectorResize ("connector" & x)
         show group ("connector" & x) of me
         if tLevelConnectors[x] is not empty then
            setConnectorIcon the long id of group ("connector" & x) of me, tLevelConnectors[x]
            set the left of group ("connector" & x) of me to item 1 of pControlRect + (x-1)*20
         else
            setConnectorIcon the long id of group ("connector" & x) of me, empty
            set the left of group ("connector" & x) of me to item 1 of pControlRect + (x-1)*20
         end if
      end if
   end repeat
   
   local tNameFieldLeft
   if revIDEGetPreference("pb_indicator") is "text" then
      set the left of group "disclosure" of me to the right of group ("connector" & tConnectorCount) of me
      set the width of field "type" of me to the formattedWidth of field "type" of me
      set the left of field "type" of me to the right of group "disclosure" of me
      put the right of field "type" of me - 5 into tNameFieldLeft
   else
      set the left of group "disclosure" of me to the right of group ("connector" & tConnectorCount) of me
      set the left of image "groupIcon" of me to the right of group"disclosure" of me
      put the right of image "groupIcon" of me into tNameFieldLeft
   end if
   
   set the right of button "cantSelect" of me to the item 3 of pControlRect - the palettePadding of me   
   set the right of button "visible" of me to the left of button "cantSelect" of me - the palettePadding of me   
   set the right of field "scriptLines" of me to the left of button "visible" of me  - the palettePadding of me
   set the right of grc "behaviorScriptLines1" of me to the left of field "scriptLines" of me - the palettePadding of me -2
   repeat with i = 2 to 10
      set the right of grc ("behaviorScriptLines" & i) of me to the left of grc ("behaviorScriptLines" & i - 1) of me - the palettePadding of me + 2
   end repeat
   
   ## Check the width of  the "name" field so it doesn't overrun the space
   local tNameWidth
   if the visible of grc "behaviorScriptLines1" of me then
      put the left of grc "behaviorScriptLines1" of me - tNameFieldLeft - the palettePadding of me into tNameWidth
      repeat with i = 10 down to 2
         if the visible of grc ("behaviorScriptLines" & i)  of me then
            put the left of grc  ("behaviorScriptLines" & i) of me - tNameFieldLeft - the palettePadding of me into tNameWidth
            exit repeat
         end if
      end repeat
   else
      put the left of field "scriptLines" of me - tNameFieldLeft - the palettePadding of me into tNameWidth
   end if
   
    if the width of field "name" of me > tNameWidth then
      set the width of field "name" of me to tNameWidth
   end if
   set the left of field "name" of me to tNameFieldLeft
end LayoutControl


getProp dvRowControl
   return the long id of me
end dvRowControl

setProp dvHilite[pHiliteColor] pBoolean
   # Override basic hilite feature...
   
   if pBoolean then
      set the foregroundColor of field "type" of me to revIDEColor("dataView_TextHiliteColor")
      set the foregroundColor of field "name" of me to  revIDEColor("dataView_TextHiliteColor")
      set the foregroundColor of field "scriptLines" of me to  revIDEColor("text_1")
      set the backgroundColor of field "scriptLines" of me to  revIDEColor("dataView_TextHiliteColor")
     repeat with i = 1 to 10
         set the foregroundColor of grc ("behaviorScriptLines" & i) of me to revIDEColor("text_1")
         set the backgroundColor of grc ("behaviorScriptLines" & i) of me to revIDEColor("dataView_TextHiliteColor")
      end repeat
      set the colorOverlay["color"] of image "groupIcon" of me to revIDEColor("dataView_TextHiliteColor")
      set the foregroundColor of widget "icon" of group "disclosure" of me to revIDEColor("dataView_disclosureIconHiliteColor")
      set the foregroundColor of me to revIDEColor("dataView_disclosureIconHiliteColor")
   else
      set the foregroundColor of field "type" of me to revIDEColor("text_2")
      set the foregroundColor of field "name" of me to revIDEColor("text_1")
      set the foregroundColor of field "scriptLines" of me to  revIDEColor("text_3")
      repeat with i = 1 to 10
         set the foregroundColor of grc ("behaviorScriptLines" & i) of me to  revIDEColor("text_3")
         set the backgroundColor of grc ("behaviorScriptLines" & i) of me to  revIDEColor("dataView_hiliteColor")
      end repeat
      
      if exists(the cObjectLongID of me) and the scriptStatus of the cObjectLongID of me is "error" then
         set the backgroundColor of field "scriptLines" of me to revIDEColor("dataView_scriptErrorBackgroundColor")
      else
         set the backgroundColor of field "scriptLines" of me to revIDEColor("dataView_hiliteColor")
      end if
      
       local tCPName
      repeat with i = 1 to 10
         put ("cBehaviorLongID" & i) into tCPName
         if exists(the tCPName of me) and the scriptStatus of the tCPName of me is "error" then
            set the backgroundColor of grc ("behaviorScriptLines" & i) of me to revIDEColor("dataView_scriptErrorBackgroundColor")
         else
            set the backgroundColor of grc ("behaviorScriptLines" & i) of me to revIDEColor("dataView_hiliteColor")
         end if
      end repeat
      
      set the colorOverlay of image "groupIcon" of me to empty
      set the foregroundColor of widget "icon" of group "disclosure" of me to revIDEColor("dataView_disclosureIconColor")
      set the foregroundColor of me to revIDEColor("dataView_disclosureIconColor")
   end if
end dvHilite

on mouseUp
   switch the short name of the target
      case "scriptLines"
         edit the script of the cObjectLongID of me
         break
      case "behaviorScriptLines1"
         edit the script of the cBehaviorLongID1 of me
         break
      case "behaviorScriptLines2"
         edit the script of the cBehaviorLongID2 of me
         break
      case "behaviorScriptLines3"
         edit the script of the cBehaviorLongID3 of me
         break
      case "behaviorScriptLines4"
         edit the script of the cBehaviorLongID4 of me
         break
      case "behaviorScriptLines5"
         edit the script of the cBehaviorLongID5 of me
         break
      case "behaviorScriptLines6"
         edit the script of the cBehaviorLongID6 of me
         break
      case "behaviorScriptLines7"
         edit the script of the cBehaviorLongID7 of me
         break
      case "behaviorScriptLines8"
         edit the script of the cBehaviorLongID8 of me
         break
      case "behaviorScriptLines9"
         edit the script of the cBehaviorLongID9 of me
         break
      case "behaviorScriptLines10"
         edit the script of the cBehaviorLongID10 of me
         break
      case "icon"
      case "disclosure"
         if the cState of the owner of the target is "contracted" then
            toggleGroup the cRowNumber of the owner of the owner of the target,true
         else if the cState of the owner of the target is"expanded" then
            toggleGroup  the cRowNumber of  the owner of the owner of the target,false
         end if
         break
      default
         pass mouseUp
   end switch
end mouseUp

on mouseDown pButton
   if pButton is 3 then       
      dispatch "pbRightClick" to stack "revIDEProjectBrowser" with the cObjectLongID of me
   else if the short name of the target is "name" and \
         the dvRow of me is the dvHilitedRow of the owner of me then
      set the textColor of field "name" of me to revIDEColor("text_1")
      CreateFieldEditorForField the long id of field "name" of me, "name"
   else
      pass mouseDown
   end if
end mouseDown

on toggleVisible
   if the icon of button "visible" of me is the id of image "visible_on" of card "templates" of this stack then
      set the icon of button "visible" of me to the id of image "visible_off" of card "templates" of this stack
      updateProperty the cObjectLongID of me, "visible", "false"
   else
      set the icon of button "visible" of me to the id of image "visible_on" of card "templates" of this stack
      updateProperty the cObjectLongID of me, "visible", "true"
   end if  
end toggleVisible

on toggleCantSelect
   if the icon of button "cantSelect" of me is the id of image "cantSelect_on" of card "templates" of this stack then
      set the icon of button "cantSelect" of me to the id of image "cantSelect_off" of card "templates" of this stack
      updateProperty the cObjectLongID of me, "cantSelect", "false"
   else
      set the icon of button "cantSelect" of me to the id of image "cantSelect_on" of card "templates" of this stack
      updateProperty the cObjectLongID of me, "cantSelect", "true"
   end if  
end toggleCantSelect

on mouseDoubleUp 
   if the short name of the target is "name" then
      set the textColor of field "name" of me to revIDEColor("text_1")
      CreateFieldEditorForField the long id of field "name" of me, "name"
   else 
      goToObject the cObjectLongID of me
   end if
end mouseDoubleUp

on CloseFieldEditor pFieldEditor, pRow, pKey, pClosingTriggeredBy
   # The text the user entered is different than the current value of the target field.
   set the textColor of field "name" of me to revIDEColor("text_3")
   set the text of field "name" of me to the text of pFieldEditor
   updateProperty the cObjectLongID of me, "name", the text of pFieldEditor
end CloseFieldEditor


on ExitFieldEditor pFieldEditor, pRow, pKey, pClosingTriggeredBy
   # The text the user entered is the same as the current value of the target field.
   set the textColor of field "name" of me to revIDEColor("text_3")
end ExitFieldEditor

getProp dvAcceptsDrop
   local theA, tRow, tDraggedRow, tDraggedStyle, tDraggedType
   local tNextRow, tTYpe
   put the dvRow of me into tRow
   
   put line 1 of the dragData["private"] into tDraggedRow
   put line 2 of the dragData["private"] into tDraggedStyle
   put line 3 of the dragData["private"] into tDraggedType
   
   if tRow is tDraggedRow then
      put true into theA["above"]
      put true into theA["below"]
   else if tDraggedStyle is "control" or tDraggedStyle is "group" then
      put true into theA["above"]
      put true into theA["below"]
   else if tDraggedType is "card" then
      put getNextVisibleRow(tRow) into tNextRow
      
      if tNextRow is 0 or tNextRow is empty then
         put false into theA["above"]
         put true into theA["below"]
      else
         put getRowType(tNextRow) into tType
         if tType is "card" or tType is "group" then
            put false into theA["above"]
            put true into theA["below"]
         else
            put false into theA["above"]
            put false into theA["below"]
         end if
      end if
   else
      put false into theA["above"]
      put false into theA["below"]
   end if
   return theA
end dvAcceptsDrop

command connectorResize pControl
   set the borderWidth of group pControl of me to 0
   set the showBorder of group pControl of me to false
   set the threeD of group pControl of me to false
   
   set the lockLoc of group pControl of me to true
   set the height of group pControl of me to the height of me
   set the width of group pControl of me to 20
   set the top of group pControl of me to the top of me
   
   set the width of widget "icon" of group pControl of me to 12
   set the height of widget "icon" of group pControl of me to the width of widget "icon" of group pControl of me
   set the loc of widget "icon" of group pControl  of me to the loc of group pControl of me
end connectorResize
