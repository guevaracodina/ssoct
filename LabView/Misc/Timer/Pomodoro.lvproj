<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="10008000">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Pomodoro.vi" Type="VI" URL="../Pomodoro.vi"/>
		<Item Name="Tomato-icon.ico" Type="Document" URL="../Tomato-icon.ico"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="DWDT Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/DWDTOps.llb/DWDT Error Code.vi"/>
				<Item Name="NI_AALBase.lvlib" Type="Library" URL="/&lt;vilib&gt;/Analysis/NI_AALBase.lvlib"/>
				<Item Name="Normalize Waveform.vi" Type="VI" URL="/&lt;vilib&gt;/Waveform/WDTOps.llb/Normalize Waveform.vi"/>
				<Item Name="ex_CorrectErrorChain.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/ex_CorrectErrorChain.vi"/>
				<Item Name="_Get Sound Error From Return Value.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_Get Sound Error From Return Value.vi"/>
				<Item Name="Sound Output Task ID.ctl" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Task ID.ctl"/>
				<Item Name="Sound Output Clear.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Clear.vi"/>
				<Item Name="Sound Output Wait.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Wait.vi"/>
				<Item Name="Sound Output Start.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Start.vi"/>
				<Item Name="_ArrWfmsTo2DArr.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_ArrWfmsTo2DArr.vi"/>
				<Item Name="_ArrWfmsTo1DInterleave.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_ArrWfmsTo1DInterleave.vi"/>
				<Item Name="_ArrWfmsToData.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_ArrWfmsToData.vi"/>
				<Item Name="Sound Output Write (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write (DBL).vi"/>
				<Item Name="Sound Output Write (DBL Single).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write (DBL Single).vi"/>
				<Item Name="Sound Output Write (U8).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write (U8).vi"/>
				<Item Name="Sound Output Write (SGL).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write (SGL).vi"/>
				<Item Name="Sound Output Write (I32).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write (I32).vi"/>
				<Item Name="Sound Output Write (I16).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write (I16).vi"/>
				<Item Name="Sound Output Write.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write.vi"/>
				<Item Name="Sound Data Format.ctl" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Data Format.ctl"/>
				<Item Name="Sampling Mode.ctl" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sampling Mode.ctl"/>
				<Item Name="Sound Output Configure.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Configure.vi"/>
				<Item Name="_FormatFromData (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_FormatFromData (DBL).vi"/>
				<Item Name="_FormatFromData (U8).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_FormatFromData (U8).vi"/>
				<Item Name="_FormatFromData (SGL).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_FormatFromData (SGL).vi"/>
				<Item Name="_FormatFromData (I32).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_FormatFromData (I32).vi"/>
				<Item Name="_FormatFromData (I16).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_FormatFromData (I16).vi"/>
				<Item Name="_FormatFromData.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/_FormatFromData.vi"/>
				<Item Name="Sound Output Write Simple (DBL2).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write Simple (DBL2).vi"/>
				<Item Name="Sound Output Write Simple (DBL1).vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write Simple (DBL1).vi"/>
				<Item Name="Sound Output Write Simple.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/lvsound2.llb/Sound Output Write Simple.vi"/>
				<Item Name="Dynamic To Waveform Array.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/transition.llb/Dynamic To Waveform Array.vi"/>
				<Item Name="subPlayWaveform.vi" Type="VI" URL="/&lt;vilib&gt;/sound2/PlayWaveformSource.llb/subPlayWaveform.vi"/>
				<Item Name="compatReadText.vi" Type="VI" URL="/&lt;vilib&gt;/_oldvers/_oldvers.llb/compatReadText.vi"/>
			</Item>
			<Item Name="user32.dll" Type="Document" URL="user32.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
			<Item Name="Window Refnum" Type="VI" URL="../labview_win_util32_86/WINUTIL.LLB/Window Refnum"/>
			<Item Name="Not a Window Refnum" Type="VI" URL="../labview_win_util32_86/WINUTIL.LLB/Not a Window Refnum"/>
			<Item Name="Set Window Z-Position.vi" Type="VI" URL="../labview_win_util32_86/WINUTIL.LLB/Set Window Z-Position.vi"/>
			<Item Name="Get Window RefNum.vi" Type="VI" URL="../labview_win_util32_86/WINUTIL.LLB/Get Window RefNum.vi"/>
			<Item Name="Make Window Always on Top.vi" Type="VI" URL="../labview_win_util32_86/WINUTIL.LLB/Make Window Always on Top.vi"/>
			<Item Name="Message_VI.vi" Type="VI" URL="../Message_VI.vi"/>
			<Item Name="lvsound2.dll" Type="Document" URL="/C/Program Files (x86)/National Instruments/LabVIEW 2010/resource/lvsound2.dll"/>
			<Item Name="lvanlys.dll" Type="Document" URL="/C/Program Files (x86)/National Instruments/LabVIEW 2010/resource/lvanlys.dll"/>
			<Item Name="Open File+.vi" Type="VI" URL="../wavfile.llb/Open File+.vi"/>
			<Item Name="Snd Gen Error Call Chain.vi" Type="VI" URL="../wavfile.llb/Snd Gen Error Call Chain.vi"/>
			<Item Name="Sound Format.ctl" Type="VI" URL="../wavfile.llb/Sound Format.ctl"/>
			<Item Name="Read File+ (string).vi" Type="VI" URL="../wavfile.llb/Read File+ (string).vi"/>
			<Item Name="Find First Error.vi" Type="VI" URL="../wavfile.llb/Find First Error.vi"/>
			<Item Name="Close File+.vi" Type="VI" URL="../wavfile.llb/Close File+.vi"/>
			<Item Name="Snd Read Wave File.vi" Type="VI" URL="../wavfile.llb/Snd Read Wave File.vi"/>
			<Item Name="General Error Handler.vi" Type="VI" URL="../wavfile.llb/General Error Handler.vi"/>
			<Item Name="Simple Error Handler.vi" Type="VI" URL="../wavfile.llb/Simple Error Handler.vi"/>
			<Item Name="Wav file to Waveform.vi" Type="VI" URL="../wavfile.llb/Wav file to Waveform.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="Pomodoro" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{F897B466-A836-4069-8616-1E4A2D97E37E}</Property>
				<Property Name="App_INI_GUID" Type="Str">{69192A66-C3CC-4BC7-B6E6-467BB38B7E88}</Property>
				<Property Name="Bld_buildSpecDescription" Type="Str">Pomodoro Timer</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Pomodoro</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../Timer/exe</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Destination[0].destName" Type="Str">Pomodoro.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../Timer/exe/NI_AB_PROJECTNAME.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../Timer/exe/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Exe_iconItemID" Type="Ref">/My Computer/Tomato-icon.ico</Property>
				<Property Name="Source[0].itemID" Type="Str">{54347A85-3503-4504-9B06-47C27F4AF047}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/Pomodoro.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_companyName" Type="Str">Polytechnique</Property>
				<Property Name="TgtF_fileDescription" Type="Str">Pomodoro</Property>
				<Property Name="TgtF_fileVersion.major" Type="Int">1</Property>
				<Property Name="TgtF_internalName" Type="Str">Pomodoro</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2012 Edgar Guevara</Property>
				<Property Name="TgtF_productName" Type="Str">Pomodoro</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{7315F88D-B001-48CC-83C3-636BFF27E52E}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">Pomodoro.exe</Property>
			</Item>
		</Item>
	</Item>
</Project>
