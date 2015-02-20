﻿script "revinitialisationlibrary"
// A array that stores whether a library is loaded
// sLoadedLibraries["library name"] = true
local sLoadedLibraries

command revInternal__LoadLibrary pLibraryName
   // Create the path to the library file. Assumption is made that the directory, file and stack name are all the same.
   //set the itemdel to "/"
   
   -- SN-2015-02-20: Linux uses case-sensitive filenames, so we
   --  follow the lower-case naming of the library names
   put toLower(pLibraryName) into pLibraryName

   if sLoadedLibraries[pLibraryName] then
      return "Library" && pLibraryName && "already loaded"
   end if
   
   // AL-2015-02-20: [[ IDE Restructure ]] Look for libraries in the correct locations.
   if the environment is "development" then
      local tLibraryPath
      if not revEnvironmentIsInstalled() and there is a file (revEnvironmentRepositoryPath() & slash & "ide-support" & slash & pLibraryName & "/" & pLibraryName & ".livecodescript") then put revEnvironmentRepositoryPath() & slash & "ide-support" & slash & pLibraryName & "/" & pLibraryName & ".livecodescript" into tLibraryPath
      else if not revEnvironmentIsInstalled() and there is a file (revEnvironmentRepositoryPath() & slash & "ide-support" & slash & pLibraryName & ".livecodescript") then put revEnvironmentRepositoryPath() & slash & "ide-support" & slash & pLibraryName & ".livecodescript" into tLibraryPath
      else if there is a file (revEnvironmentToolsetPath() & "/libraries/" & pLibraryName & "/" & pLibraryName & ".livecodescript") then put revEnvironmentToolsetPath() & "/libraries/" & pLibraryName & "/" & pLibraryName & ".livecodescript" into tLibraryPath
      else if there is a file (revEnvironmentToolsetPath() & "/libraries/" & pLibraryName & ".livecodescript") then put revEnvironmentToolsetPath() & "/libraries/" & pLibraryName & ".livecodescript" into tLibraryPath
      else return "no file for library" && pLibraryName
      
      try
      	--local tDefaultStack
      	--put the defaultStack into tDefaultStack
         // Open the stack
        -- go stack tLibraryPath
         
         --set the defaultStack to tDefaultStack
         
         // Get it's name
         local tStackName
         put the name of stack tLibraryPath into tStackName
         
         // Insert the script into the backscript
         send "revLoadLibrary" to stack tStackName
         
         put true into sLoadedLibraries[pLibraryName]
         
         return true
      catch tError
         put tError
         return "Error while loading stack:" && tLibraryPath
      end try
      
   else
      try
         send "revLoadLibrary" to stack pLibraryName
      catch tError
         return "Error" && tError && "while loading stack:" && pLibraryName
      end try
   end if
end revInternal__LoadLibrary

command revInternal__UnloadLibrary pLibraryName
   // Check if the library is loaded
   if sLoadedLibraries[pLibraryName] is not true then
      return "Library not loaded"
   end if
   
   if there is not a stack pLibraryName then return "library not loaded"
   
   try
      // Request the library shuts down
      send "revUnloadLibrary" to stack pLibraryName
      
      delete variable sLoadedLibraries[pLibraryName]
      
      return true
   catch tError
      return "Error while unloading library. Library" && pLibraryName && "did not complete the reVUnloadLibrary request"
   end try
end revInternal__UnloadLibrary

function revInternal__ListLoadedLibraries
   local tLibs
   put the keys of sLoadedLibraries into tLibs
   sort tLibs
   return tLibs
end revInternal__ListLoadedLibraries

command revInternal__SetAppIcon pAppIcon
   global gRevAppIcon
   set the paintCompression to "png" -- match the engine
   put pAppIcon into gRevAppIcon
end revInternal__SetAppIcon

command revInternal__SetSmallAppIcon pSmallAppIcon
   global gRevSmallAppIcon
   set the paintCompression to "png" -- match the engine
   put pSmallAppIcon into gRevAppIcon
end revInternal__SetSmallAppIcon