class welcomeScreen
{
	idd = 6969

	class controls
	{
		class welcomeFrame: IGUIBackMRTM
		{
			idc = 69697;
			deletable = 0;
			x = 0.250656 * safezoneW + safezoneX;
			y = 0.171 * safezoneH + safezoneY;
			w = 0.499688 * safezoneW;
			h = 0.671 * safezoneH;
			colorText[] = {1,1,1,1};
		};

		class welcomeMain: IGUIBackMRTM
		{
			idc = 69690;
			deletable = 0;
			x = 0.257656 * safezoneW + safezoneX;
			y = 0.181 * safezoneH + safezoneY;
			w = 0.484688 * safezoneW;
			h = 0.649 * safezoneH;
			colorText[] = {1,1,1,1};
			colorActive[] = {1,1,1,1};
		};

		class welcomeMainImg: RscPictureMRTM
		{
			idc = 69691;
			deletable = 0;
			text = "img\altis.paa";
			style = ST_MULTI + ST_TITLE_BAR;
			x = 0.257656 * safezoneW + safezoneX;
			y = 0.181 * safezoneH + safezoneY;
			w = 0.484688 * safezoneW;
			h = 0.649 * safezoneH;
		};

		class welcomeText: RscStructuredTextMRTM
		{
			idc = 69692;
			deletable = 0;
			text = "Warlords Redux v2.5"; //--- ToDo: Localize;
			x = 0.288594 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.149531 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class welcomeSlidePic: RscPictureMRTM
		{
			idc = 69694;
			deletable = 0;
			text = "";
			style = ST_MULTI + ST_TITLE_BAR + ST_KEEP_ASPECT_RATIO;
			x = 0.288594 * safezoneW + safezoneX;
			y = 0.588 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.209 * safezoneH;
		};

		class welcomeListFrame: RscFrameMRTM
		{
			type = CT_STATIC;
			idc = 69698;
			deletable = 0;
			style = ST_FRAME;
			colorBackground[] = {0,0,0,0};
			x = 0.288594 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.286 * safezoneH;
		};

		class welcomeTextBlockFrame: RscFrameMRTM
		{
			type = CT_STATIC;
			idc = 69698;
			deletable = 0;
			style = ST_FRAME;
			colorBackground[] = {0,0,0,0};
			x = 0.485469 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.245937 * safezoneW;
			h = 0.528 * safezoneH;
		};

		class welcomeControlGroup: RscControlsGroup
		{
			deletable = 0;
			fade = 0;
			class VScrollbar: ScrollBar
			{
				color[] = {1,1,1,1};
				height = 0.528;
				width = 0.021;
				autoScrollEnabled = 1;
			};

			class HScrollbar: ScrollBar
			{
				color[] = {1,1,1,1};
				height = 0;
				width = 0;
			};

			class Controls
			{
				class welcomeTextBlock: RscStructuredTextMRTM
				{
					idc = 69696;
					deletable = 0;
					type = CT_STRUCTURED_TEXT;
					style = ST_LEFT;
					w = 0.245937 * safezoneW;
					h = 3 * safezoneH;
				};	
			};

			type = CT_CONTROLS_GROUP;
			idc = -1;
			x = 0.485469 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.255937 * safezoneW;
			h = 0.528 * safezoneH;
			shadow = 0;
			style = ST_MULTI;
		};

		class welcomeList: RscListboxMRTM
		{
			idc = 69695;
			deletable = 0;
			x = 0.288594 * safezoneW + safezoneX;
			y = 0.269 * safezoneH + safezoneY;
			w = 0.190781 * safezoneW;
			h = 0.286 * safezoneH;
		};

		class welcomeLang: RscComboMRTM
		{
			idc = 69699;
			deletable = 0;
			type = CT_COMBO;
			colorBackground[] = {0,0,0,0};
			arrowEmpty = "\A3\3den\data\controls\ctrlcombo\arrowEmpty_ca.paa";
			arrowFull = "\A3\3den\data\controls\ctrlcombo\arrowEmpty_ca.paa";
			x = 0.649219 * safezoneW + safezoneX;
			y = 0.220 * safezoneH + safezoneY;
			w = 0.0781875 * safezoneW;
			h = 0.033 * safezoneH;
		};

		class welcomeLangPic: RscPictureMRTM
		{
			idc = 696990;
			deletable = 0;
			text = "";
			style = ST_MULTI + ST_TITLE_BAR + ST_KEEP_ASPECT_RATIO;
			x = 0.615219 * safezoneW + safezoneX;
			y = 0.215 * safezoneH + safezoneY;
			w = 0.0271875 * safezoneW;
			h = 0.040 * safezoneH;
		};
	};
};