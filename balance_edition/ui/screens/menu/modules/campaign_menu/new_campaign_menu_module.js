/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2015
 *
 *  @Author:		Overhype Studios
 *  @Date:			03.03.2015
 *  @Description:	New Campaign Menu Module JS
 */
"use strict";

var NewCampaignMenuModule = function () {
	this.mSQHandle = null;

	// event listener
	this.mEventListener = null;

	// generic containers
	this.mContainer = null;
	this.mDialogContainer = null;

	this.mFirstPanel = null;
	this.mSecondPanel = null;
	this.mThirdPanel = null;
	this.mMapPanel = null;
	this.mConfigPanel = null;

	// controls
	this.mDifficultyEasyCheckbox = null;
	this.mDifficultyEasyLabel = null;
	this.mDifficultyNormalCheckbox = null;
	this.mDifficultyNormalLabel = null;
	this.mDifficultyHardCheckbox = null;
	this.mDifficultyHardLabel = null;
	this.mDifficultyLegendaryCheckbox = null;
	this.mDifficultyLegendaryLabel = null;

	this.mEconomicDifficultyEasyCheckbox = null;
	this.mEconomicDifficultyEasyLabel = null;
	this.mEconomicDifficultyNormalCheckbox = null;
	this.mEconomicDifficultyNormalLabel = null;
	this.mEconomicDifficultyHardCheckbox = null;
	this.mEconomicDifficultyHardLabel = null;
	this.mEconomicDifficultyLegendaryCheckbox = null;
	this.mEconomicDifficultyLegendaryLabel = null;

	this.mBudgetDifficultyEasyCheckbox = null;
	this.mBudgetDifficultyEasyLabel = null;
	this.mBudgetDifficultyNormalCheckbox = null;
	this.mBudgetDifficultyNormalLabel = null;
	this.mBudgetDifficultyHardCheckbox = null;
	this.mBudgetDifficultyHardLabel = null;
	this.mBudgetDifficultyLegendaryCheckbox = null;
	this.mBudgetDifficultyLegendaryLabel = null;

	this.mIronmanCheckbox = null;
	this.mIronmanCheckboxLabel = null;
	this.mAutosaveCheckbox = null;
	this.mAutosaveCheckboxLabel = null;
	this.mCompanyName = null;

	this.mEvilRandomCheckbox = null;
	this.mEvilRandomLabel = null;
	this.mEvilWarCheckbox = null;
	this.mEvilWarLabel = null;
	this.mEvilGreenskinsCheckbox = null;
	this.mEvilGreenskinsLabel = null;
	this.mEvilUndeadCheckbox = null;
    this.mEvilUndeadLabel = null;
    this.mEvilCrusadeCheckbox = null;
    this.mEvilCrusadeLabel = null;
    this.mEvilCrusadeControl = null;
	this.mEvilNoneCheckbox = null;
	this.mEvilNoneLabel = null;
	this.mEvilNoDesctructionCheckbox = null;
	this.mEvilPermanentDestructionLabel = null;

	this.mPrevBannerButton = null;
	this.mNextBannerButton = null;
	this.mBannerImage = null;

	this.mSeed = null;

	// buttons
	this.mStartButton = null;
	this.mCancelButton = null;

	// banners
	this.mBanners = null;
	this.mCurrentBannerIndex = 0;

	// difficulty
	this.mDifficulty = 0;
	this.mEconomicDifficulty = 0;
	this.mBudgetDifficulty = 0;
	this.mEvil = 0;

	// scenario
	this.mScenarios = null;
	this.mSelectedScenario = 0;
	this.mScenarioContainer = null;
	this.mScenarioScrollContainer = null;

	this.mGenderLevel = 2;

	// Map config
	this.mMapOptions = {
		Width: {
			Control: null,
			Title: null,
			OptionsKey: 'map.width',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		Height: {
			Control: null,
			Title: null,
			OptionsKey: 'map.height',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		LandMassMult: {
			Control: null,
			Title: null,
			OptionsKey: 'map.landmassmult',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		WaterConnectivity: {
			Control: null,
			Title: null,
			OptionsKey: 'map.waterconnectivity',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		MinLandToWaterRatio: {
			Control: null,
			Title: null,
			OptionsKey: 'map.minlandtowaterratio',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		Snowline: {
			Control: null,
			Title: null,
			OptionsKey: 'map.snowline',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		Vision: {
			Control: null,
			Title: null,
			OptionsKey: 'map.vision',
			Min: 0,
			Max: 5000,
			Value: 500,
			Step: 100,
		},
		NumSettlements: {
			Control: null,
			Title: null,
			OptionsKey: 'map.settlements',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		NumFactions: {
			Control: null,
			Title: null,
			OptionsKey: 'map.factions',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		ForestsMult: {
			Control: null,
			Title: null,
			OptionsKey: 'map.forests',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		SwampsMult: {
			Control: null,
			Title: null,
			OptionsKey: 'map.swamps',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		MountainsMult: {
			Control: null,
			Title: null,
			OptionsKey: 'map.mountains',
			Min: 0,
			Max: 0,
			Value: 0,
			Step: 1
		},
		FOW: true,
		Debug: false,
		StackCitadels: false,
		AllTradeLocations: false
	};

	this.mMapConfigOpts = {};

	this.mFogofWarCheckbox = null;
	this.mFogofWarCheckboxLabel = null;
	this.mDebugCheckbox = null;
	this.mDebugCheckboxLabel = null;
	this.mStackCitadelsCheckbox = null;
	this.mStackCitadelsCheckboxLabel = null;
	this.mAllTradeLocationsCheckbox = null;
	this.mAllTradeLocationsCheckboxLabel = null;
	this.mLegendPerkTreesCheckbox = null;
	this.mLegendPerkTreesCheckboxLabel = null;
	this.mLegendGenderEqualityCheckbox = null;
	this.mLegendGenderEqualityCheckboxLabel = null;
	this.mLegendMagicCheckbox = null;
	this.mLegendMagicCheckboxLabel = null;
	this.mLegendArmorCheckbox = null;
	this.mLegendArmorCheckboxLabel = null;
	this.mLegendItemScalingCheckbox = null;
	this.mLegendItemScalingCheckboxLabel = null;
	this.mLegendLocationScalingCheckbox = null;
	this.mLegendLocationScalingCheckboxLabel = null;
	this.mLegendCampUnlockCheckbox = null;
	this.mLegendCampUnlockCheckboxLabel = null;
	this.mLegendRecruitScalingCheckbox = null;
	this.mLegendRecruitScalingCheckboxLabel = null;
	this.mLegendBleedKillerCheckbox = null;
	this.mLegendBleedKillerCheckboxLabel = null;
	this.mLegendAllBlueprintsCheckbox = null;
	this.mLegendAllBlueprintsCheckboxLabel = null;
	this.mLegendTherianCheckbox = null;
	this.mLegendTherianCheckboxLabel = null;
	this.mLegendWorldEconomyCheckbox = null;
	this.mLegendWorldEconomyCheckboxLabel = null;
	// generics
	this.mIsVisible = false;
};


NewCampaignMenuModule.prototype.isConnected = function () {
	return this.mSQHandle !== null;
};

NewCampaignMenuModule.prototype.onConnection = function (_handle) {
	this.mSQHandle = _handle;

	// notify listener
	if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener)) {
		this.mEventListener.onModuleOnConnectionCalled(this);
	}
};

NewCampaignMenuModule.prototype.onDisconnection = function () {
	this.mSQHandle = null;

	// notify listener
	if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener)) {
		this.mEventListener.onModuleOnDisconnectionCalled(this);
	}
};


NewCampaignMenuModule.prototype.createDIV = function (_parentDiv) {
	var self = this;

	// create: dialog container
	this.mContainer = $('<div class="new-campaign-menu-module display-none"/>');
	_parentDiv.append(this.mContainer);
	this.mDialogContainer = this.mContainer.createDialog('New Campaign', null, null /*Path.GFX + Asset.HEADER_TACTICAL_COMBAT_DIALOG*/ , false, 'dialog-800-720-2');

	// create: content
	var contentContainer = this.mDialogContainer.findDialogContentContainer();

	this.mSecondPanel = $('<div class="display-block"/>');
	contentContainer.append(this.mSecondPanel); {
		var leftColumn = $('<div class="column"/>');
		this.mSecondPanel.append(leftColumn);
		var rightColumn = $('<div class="column"/>');
		this.mSecondPanel.append(rightColumn);

		// name
		var row = $('<div class="row" />');
		leftColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Company Name</div>');
		row.append(title);

		var inputLayout = $('<div class="l-input"/>');
		row.append(inputLayout);
		this.mCompanyName = inputLayout.createInput('Battle Brothers', 0, 32, 1, function (_input) {
			if (self.mStartButton !== null) self.mStartButton.enableButton(_input.getInputTextLength() >= 1);
		}, 'title-font-big font-bold font-color-brother-name');
		this.mCompanyName.setInputText('Battle Brothers');

		// greater evil
		var row = $('<div class="row" />');
		leftColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Late Game Crisis</div>');
		row.append(title);

		var evilRandomControl = $('<div class="control"></div>');
		row.append(evilRandomControl);
		this.mEvilRandomCheckbox = $('<input type="radio" id="cb-evil-random" name="evil" checked />');
		evilRandomControl.append(this.mEvilRandomCheckbox);
		this.mEvilRandomLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-evil-random">Random</label>');
		evilRandomControl.append(this.mEvilRandomLabel);
		this.mEvilRandomCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEvilRandomCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEvil = 0;
		});

		var evilWarControl = $('<div class="control"></div>');
		row.append(evilWarControl);
		this.mEvilWarCheckbox = $('<input type="radio" id="cb-evil-war" name="evil"/>');
		evilWarControl.append(this.mEvilWarCheckbox);
		this.mEvilWarLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-evil-war">Nobles at War</label>');
		evilWarControl.append(this.mEvilWarLabel);
		this.mEvilWarCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEvilWarCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEvil = 1;
		});

		var evilGreenskinsControl = $('<div class="control"></div>');
		row.append(evilGreenskinsControl);
		this.mEvilGreenskinsCheckbox = $('<input type="radio" id="cb-evil-greenskins" name="evil"/>');
		evilGreenskinsControl.append(this.mEvilGreenskinsCheckbox);
		this.mEvilGreenskinsLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-evil-greenskins">Greenskin Invasion</label>');
		evilGreenskinsControl.append(this.mEvilGreenskinsLabel);
		this.mEvilGreenskinsCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEvilGreenskinsCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEvil = 2;
		});

		var evilUndeadControl = $('<div class="control"></div>');
		row.append(evilUndeadControl);
		this.mEvilUndeadCheckbox = $('<input type="radio" id="cb-evil-undead" name="evil"/>');
		evilUndeadControl.append(this.mEvilUndeadCheckbox);
		this.mEvilUndeadLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-evil-undead">Undead Scourge</label>');
		evilUndeadControl.append(this.mEvilUndeadLabel);
		this.mEvilUndeadCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEvilUndeadCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEvil = 3;
        });

        this.mEvilCrusadeControl = $('<div class="control"></div>');
        row.append(this.mEvilCrusadeControl);
        this.mEvilCrusadeCheckbox = $('<input type="radio" id="cb-evil-crusade" name="evil"/>');
        this.mEvilCrusadeControl.append(this.mEvilCrusadeCheckbox);
        this.mEvilCrusadeLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-evil-crusade">Holy War</label>');
        this.mEvilCrusadeControl.append(this.mEvilCrusadeLabel);
        this.mEvilCrusadeCheckbox.iCheck({
            checkboxClass: 'icheckbox_flat-orange',
            radioClass: 'iradio_flat-orange',
            increaseArea: '30%'
        });
        this.mEvilCrusadeCheckbox.on('ifChecked', null, this, function (_event)
        {
            var self = _event.data;
            self.mEvil = 4;
        });

        var space = $('<div class="control permanent-destruction-control"/>');
        row.append(space);

		var extraLateControl = $('<div class="control permanent-destruction-control"/>');
		row.append(extraLateControl);
		this.mEvilPermanentDestructionCheckbox = $('<input type="checkbox" id="cb-extra-late" checked/>');
		extraLateControl.append(this.mEvilPermanentDestructionCheckbox);
		this.mEvilPermanentDestructionLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-extra-late">Permanent Destruction</label>');
		extraLateControl.append(this.mEvilPermanentDestructionLabel);
		this.mEvilPermanentDestructionCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});

		// banner
		var row = $('<div class="row" />');
		rightColumn.append(row);
		//var title = $('<div class="title title-font-big font-color-title">Banner</div>');
		//row.append(title);

		var bannerContainer = $('<div class="banner-container" />');
		row.append(bannerContainer);

		var table = $('<table width="100%" height="100%"><tr><td width="10%"><div class="l-button prev-banner-button" /></td><td width="80%" class="banner-image-container"></td><td width="10%"><div class="l-button next-banner-button" /></td></tr></table>');
		bannerContainer.append(table);

		var prevBanner = table.find('.prev-banner-button:first');
		this.mPrevBannerButton = prevBanner.createImageButton(Path.GFX + Asset.BUTTON_PREVIOUS_BANNER, function () {
			self.onPreviousBannerClicked();
		}, '', 6);

		var nextBanner = table.find('.next-banner-button:first');
		this.mNextBannerButton = nextBanner.createImageButton(Path.GFX + Asset.BUTTON_NEXT_BANNER, function () {
			self.onNextBannerClicked();
		}, '', 6);

		var bannerImage = table.find('.banner-image-container:first');
		this.mBannerImage = bannerImage.createImage(Path.GFX + 'ui/banners/banner_01.png', function (_image) {
			_image.removeClass('display-none').addClass('display-block');
			//_image.centerImageWithinParent();
		}, null, 'display-none banner-image');

		// seed
		var row = $('<div class="row map-seed-control" />');
		leftColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Map Seed</div>');
		row.append(title);

		var inputLayout = $('<div class="l-input"/>');
		row.append(inputLayout);
		this.mSeed = inputLayout.createInput('', 0, 10, 1, null, 'title-font-big font-bold font-color-brother-name');
	}

	this.mThirdPanel = $('<div class="display-none"/>');
	contentContainer.append(this.mThirdPanel); {
		var leftColumn = $('<div class="column"/>');
		this.mThirdPanel.append(leftColumn);
		var rightColumn = $('<div class="column"/>');
		this.mThirdPanel.append(rightColumn);

		// economic difficulty
		var row = $('<div class="row" />');
		leftColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Economic Difficulty</div>');
		row.append(title);

		var easyDifficultyControl = $('<div class="control"></div>');
		row.append(easyDifficultyControl);
		this.mEconomicDifficultyEasyCheckbox = $('<input type="radio" id="cb-economic-difficulty-easy" name="economic-difficulty" checked />');
		easyDifficultyControl.append(this.mEconomicDifficultyEasyCheckbox);
		this.mEconomicDifficultyEasyLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-economic-difficulty-easy">Beginner</label>');
		easyDifficultyControl.append(this.mEconomicDifficultyEasyLabel);
		this.mEconomicDifficultyEasyCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEconomicDifficultyEasyCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEconomicDifficulty = 0;
		});

		var normalDifficultyControl = $('<div class="control"></div>');
		row.append(normalDifficultyControl);
		this.mEconomicDifficultyNormalCheckbox = $('<input type="radio" id="cb-economic-difficulty-normal" name="economic-difficulty" />');
		normalDifficultyControl.append(this.mEconomicDifficultyNormalCheckbox);
		this.mEconomicDifficultyNormalLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-economic-difficulty-normal">Veteran</label>');
		normalDifficultyControl.append(this.mEconomicDifficultyNormalLabel);
		this.mEconomicDifficultyNormalCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEconomicDifficultyNormalCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEconomicDifficulty = 1;
		});

		var hardDifficultyControl = $('<div class="control"></div>');
		row.append(hardDifficultyControl);
		this.mEconomicDifficultyHardCheckbox = $('<input type="radio" id="cb-economic-difficulty-hard" name="economic-difficulty" />');
		hardDifficultyControl.append(this.mEconomicDifficultyHardCheckbox);
		this.mEconomicDifficultyHardLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-economic-difficulty-hard">Expert</label>');
		hardDifficultyControl.append(this.mEconomicDifficultyHardLabel);
		this.mEconomicDifficultyHardCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEconomicDifficultyHardCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEconomicDifficulty = 2;
		});


		var LegendaryDifficultyControl = $('<div class="control"></div>');
		row.append(LegendaryDifficultyControl);
		this.mEconomicDifficultyLegendaryCheckbox = $('<input type="radio" id="cb-economic-difficulty-Legendary" name="economic-difficulty" />');
		LegendaryDifficultyControl.append(this.mEconomicDifficultyLegendaryCheckbox);
		this.mEconomicDifficultyLegendaryLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-economic-difficulty-Legendary">Legendary</label>');
		LegendaryDifficultyControl.append(this.mEconomicDifficultyLegendaryLabel);
		this.mEconomicDifficultyLegendaryCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mEconomicDifficultyLegendaryCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mEconomicDifficulty = 3;
		});

		// starting budget difficulty
		var row = $('<div class="row" />');
		leftColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Starting Funds</div>');
		row.append(title);

		var easyDifficultyControl = $('<div class="control"></div>');
		row.append(easyDifficultyControl);
		this.mBudgetDifficultyEasyCheckbox = $('<input type="radio" id="cb-budget-difficulty-easy" name="budget-difficulty" checked />');
		easyDifficultyControl.append(this.mBudgetDifficultyEasyCheckbox);
		this.mBudgetDifficultyEasyLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-budget-difficulty-easy">High</label>');
		easyDifficultyControl.append(this.mBudgetDifficultyEasyLabel);
		this.mBudgetDifficultyEasyCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mBudgetDifficultyEasyCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mBudgetDifficulty = 0;
		});

		var normalDifficultyControl = $('<div class="control"></div>');
		row.append(normalDifficultyControl);
		this.mBudgetDifficultyNormalCheckbox = $('<input type="radio" id="cb-budget-difficulty-normal" name="budget-difficulty" />');
		normalDifficultyControl.append(this.mBudgetDifficultyNormalCheckbox);
		this.mBudgetDifficultyNormalLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-budget-difficulty-normal">Medium</label>');
		normalDifficultyControl.append(this.mBudgetDifficultyNormalLabel);
		this.mBudgetDifficultyNormalCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mBudgetDifficultyNormalCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mBudgetDifficulty = 1;
		});

		var hardDifficultyControl = $('<div class="control"></div>');
		row.append(hardDifficultyControl);
		this.mBudgetDifficultyHardCheckbox = $('<input type="radio" id="cb-budget-difficulty-hard" name="budget-difficulty" />');
		hardDifficultyControl.append(this.mBudgetDifficultyHardCheckbox);
		this.mBudgetDifficultyHardLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-budget-difficulty-hard">Low</label>');
		hardDifficultyControl.append(this.mBudgetDifficultyHardLabel);
		this.mBudgetDifficultyHardCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mBudgetDifficultyHardCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mBudgetDifficulty = 2;
		});

		var LegendaryDifficultyControl = $('<div class="control"></div>');
		row.append(LegendaryDifficultyControl);
		this.mBudgetDifficultyLegendaryCheckbox = $('<input type="radio" id="cb-budget-difficulty-Legendary" name="budget-difficulty" />');
		LegendaryDifficultyControl.append(this.mBudgetDifficultyLegendaryCheckbox);
		this.mBudgetDifficultyLegendaryLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-budget-difficulty-Legendary">None</label>');
		LegendaryDifficultyControl.append(this.mBudgetDifficultyLegendaryLabel);
		this.mBudgetDifficultyLegendaryCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mBudgetDifficultyLegendaryCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mBudgetDifficulty = 3;
		});

		// combat difficulty
		var row = $('<div class="row" />');
		rightColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Combat Difficulty</div>');
		row.append(title);

		var easyDifficultyControl = $('<div class="control"></div>');
		row.append(easyDifficultyControl);
		this.mDifficultyEasyCheckbox = $('<input type="radio" id="cb-difficulty-easy" name="difficulty" checked />');
		easyDifficultyControl.append(this.mDifficultyEasyCheckbox);
		this.mDifficultyEasyLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-difficulty-easy">Beginner</label>');
		easyDifficultyControl.append(this.mDifficultyEasyLabel);
		this.mDifficultyEasyCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mDifficultyEasyCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mDifficulty = 0;
		});

		var normalDifficultyControl = $('<div class="control"></div>');
		row.append(normalDifficultyControl);
		this.mDifficultyNormalCheckbox = $('<input type="radio" id="cb-difficulty-normal" name="difficulty" />');
		normalDifficultyControl.append(this.mDifficultyNormalCheckbox);
		this.mDifficultyNormalLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-difficulty-normal">Veteran</label>');
		normalDifficultyControl.append(this.mDifficultyNormalLabel);
		this.mDifficultyNormalCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mDifficultyNormalCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mDifficulty = 1;
		});

		var hardDifficultyControl = $('<div class="control"></div>');
		row.append(hardDifficultyControl);
		this.mDifficultyHardCheckbox = $('<input type="radio" id="cb-difficulty-hard" name="difficulty" />');
		hardDifficultyControl.append(this.mDifficultyHardCheckbox);
		this.mDifficultyHardLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-difficulty-hard">Expert</label>');
		hardDifficultyControl.append(this.mDifficultyHardLabel);
		this.mDifficultyHardCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mDifficultyHardCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mDifficulty = 2;
		});

		var LegendaryDifficultyControl = $('<div class="control"></div>');
		row.append(LegendaryDifficultyControl);
		this.mDifficultyLegendaryCheckbox = $('<input type="radio" id="cb-difficulty-Legendary" name="difficulty" />');
		LegendaryDifficultyControl.append(this.mDifficultyLegendaryCheckbox);
		this.mDifficultyLegendaryLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-difficulty-Legendary">Legendary</label>');
		LegendaryDifficultyControl.append(this.mDifficultyLegendaryLabel);
		this.mDifficultyLegendaryCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
		this.mDifficultyLegendaryCheckbox.on('ifChecked', null, this, function (_event) {
			var self = _event.data;
			self.mDifficulty = 3;
		});

		// combat difficulty
		var row = $('<div class="row" />');
		rightColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Ironman Mode</div>');
		row.append(title);

		var ironmanControl = $('<div class="control ironman-control"/>');
		row.append(ironmanControl);
		this.mIronmanCheckbox = $('<input type="checkbox" id="cb-iron-man"/>');
		ironmanControl.append(this.mIronmanCheckbox);
		this.mIronmanCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-iron-man">Ironman</label>');
		ironmanControl.append(this.mIronmanCheckboxLabel);
		this.mIronmanCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});

		var autosaveControl = $('<div class="control autosave-control"/>');
		row.append(autosaveControl);
		this.mAutosaveCheckbox = $('<input type="checkbox" id="cb-autosave"/>');
		autosaveControl.append(this.mAutosaveCheckbox);
		this.mAutosaveCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-autosave">Autosave Off</label>');
		autosaveControl.append(this.mAutosaveCheckboxLabel);
		this.mAutosaveCheckbox.iCheck({
			checkboxClass: 'icheckbox_flat-orange',
			radioClass: 'iradio_flat-orange',
			increaseArea: '30%'
		});
	}

	this.mFirstPanel = $('<div class="display-none"/>');
	contentContainer.append(this.mFirstPanel); {
		var leftColumn = $('<div class="column2"/>');
		this.mFirstPanel.append(leftColumn);
		var rightColumn = $('<div class="column3"/>');
		this.mFirstPanel.append(rightColumn);

		// starting scenario
		var row = $('<div class="row" />');
		leftColumn.append(row);
		var title = $('<div class="title title-font-big font-color-title">Company Origin</div>');
		row.append(title);
		//this.mScenariosRow = row;

		var listContainerLayout = $('<div class="l-list-container"/>');
		row.append(listContainerLayout);
		this.mScenarioContainer = listContainerLayout.createList(8.85);
		this.mScenarioScrollContainer = this.mScenarioContainer.findListScrollContainer();

		var row = $('<div class="row3 text-font-medium font-color-description" />');
		rightColumn.append(row);
		this.mScenariosDesc = row;

		this.mScenariosDifficulty = row.createImage('', function (_image) {
			_image.removeClass('display-none').addClass('display-block');
		}, null, 'display-none difficulty');
		rightColumn.append(this.mScenariosDifficulty);
	}

	this.mMapPanel = $('<div class="display-none"/>');
	contentContainer.append(this.mMapPanel);
	this.buildMapConfig();

	this.mConfigPanel = $('<div class="display-none"/>');
	contentContainer.append(this.mConfigPanel);
	this.buildConfigPage();


	// create footer button bar
	var footerButtonBar = $('<div class="l-button-bar"></div>');
	this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

	var layout = $('<div class="l-random-button"/>');
	footerButtonBar.append(layout);
	this.mRandomButton = layout.createTextButton("Random", function () {
		self.randomizeMapConfig();
	}, '', 1);
	this.mRandomButton.addClass('display-none')

	var layout = $('<div class="l-ok-button"/>');
	footerButtonBar.append(layout);
	this.mStartButton = layout.createTextButton("Next", function () {
		self.advanceScreen();
	}, '', 1);

	layout = $('<div class="l-cancel-button"/>');
	footerButtonBar.append(layout);
	this.mCancelButton = layout.createTextButton("Cancel", function () {
		if (self.mFirstPanel.hasClass('display-block')) {
			self.notifyBackendCancelButtonPressed();
		} else if (self.mSecondPanel.hasClass('display-block')) {
			self.mFirstPanel.removeClass('display-none').addClass('display-block');
			self.mSecondPanel.removeClass('display-block').addClass('display-none');
			self.mThirdPanel.removeClass('display-block').addClass('display-none');
			self.mMapPanel.removeClass('display-block').addClass('display-none');
			self.mConfigPanel.removeClass('display-block').addClass('display-none');
			self.mStartButton.changeButtonText("Next");
			self.mCancelButton.changeButtonText("Cancel");
			self.mRandomButton.removeClass('display-block').addClass('display-none');
		} else if (self.mThirdPanel.hasClass('display-block')) {
			self.mFirstPanel.removeClass('display-block').addClass('display-none');
			self.mSecondPanel.removeClass('display-none').addClass('display-block');
			self.mThirdPanel.removeClass('display-block').addClass('display-none');
			self.mMapPanel.removeClass('display-block').addClass('display-none');
			self.mConfigPanel.removeClass('display-block').addClass('display-none');
			self.mStartButton.changeButtonText("Next");
			self.mCancelButton.changeButtonText("Previous");
			self.mRandomButton.removeClass('display-block').addClass('display-none');
		} else if (self.mMapPanel.hasClass('display-block')) {
			self.mFirstPanel.removeClass('display-block').addClass('display-none');
			self.mSecondPanel.removeClass('display-block').addClass('display-none');
			self.mThirdPanel.removeClass('display-none').addClass('display-block');
			self.mMapPanel.removeClass('display-block').addClass('display-none');
			self.mConfigPanel.removeClass('display-block').addClass('display-none');
			self.mStartButton.changeButtonText("Next");
			self.mCancelButton.changeButtonText("Previous");
			self.mRandomButton.removeClass('display-block').addClass('display-none');
		} else {
			self.mFirstPanel.removeClass('display-block').addClass('display-none');
			self.mSecondPanel.removeClass('display-block').addClass('display-none');
			self.mThirdPanel.removeClass('display-block').addClass('display-none');
			self.mMapPanel.removeClass('display-none').addClass('display-block');
			self.mConfigPanel.removeClass('display-block').addClass('display-none');
			self.mStartButton.changeButtonText("Next");
			self.mCancelButton.changeButtonText("Previous");
			self.mRandomButton.removeClass('display-none').addClass('display-block');
		}

	}, '', 1);

	this.mIsVisible = false;
};

NewCampaignMenuModule.prototype.destroyDIV = function () {
	// controls
	this.mDifficultyEasyCheckbox.remove();
	this.mDifficultyEasyCheckbox = null;
	this.mDifficultyEasyLabel.remove();
	this.mDifficultyEasyLabel = null;
	this.mDifficultyNormalCheckbox.remove();
	this.mDifficultyNormalCheckbox = null;
	this.mDifficultyNormalLabel.remove();
	this.mDifficultyNormalLabel = null;
	this.mDifficultyHardCheckbox.remove();
	this.mDifficultyHardCheckbox = null;
	this.mDifficultyHardLabel.remove();
	this.mDifficultyHardLabel = null;
	this.mDifficultyLegendaryCheckbox.remove();
	this.mDifficultyLegendaryCheckbox = null;
	this.mDifficultyLegendaryLabel.remove();
	this.mDifficultyLegendaryLabel = null;
	this.mCompanyName.remove();
	this.mCompanyName = null;

	this.mPrevBannerButton.remove();
	this.mPrevBannerButton = null;
	this.mNextBannerButton.remove();
	this.mNextBannerButton = null;
	this.mBannerImage.remove();
	this.mBannerImage = null;

	this.mSeed.remove();
	this.mSeed = null;

	// buttons
	this.mStartButton.remove();
	this.mStartButton = null;
	this.mCancelButton.remove();
	this.mCancelButton = null;

	this.mScenarioScrollContainer.empty();
	this.mScenarioScrollContainer = null;
	this.mScenarioContainer.destroyList();
	this.mScenarioContainer.remove();
	this.mScenarioContainer = null;

	this.mFirstPanel.empty();
	this.mFirstPanel.remove();
	this.mFirstPanel = null;

	this.mSecondPanel.empty();
	this.mSecondPanel.remove();
	this.mSecondPanel = null;

	this.mThirdPanel.empty();
	this.mThirdPanel.remove();
	this.mThirdPanel = null;

	this.mMapPanel.empty();
	this.mMapPanel.remove();
	this.mMapPanel = null;

	this.mConfigPanel.empty();
	this.mConfigPanel.remove();
	this.mConfigPanel = null;

	this.mDialogContainer.empty();
	this.mDialogContainer.remove();
	this.mDialogContainer = null;

	this.mContainer.empty();
	this.mContainer.remove();
	this.mContainer = null;
};

NewCampaignMenuModule.prototype.advanceScreen = function () {
	if (this.mFirstPanel.hasClass('display-block')) {
		this.mFirstPanel.removeClass('display-block').addClass('display-none');
		this.mSecondPanel.removeClass('display-none').addClass('display-block');
		this.mThirdPanel.removeClass('display-block').addClass('display-none');
		this.mMapPanel.removeClass('display-block').addClass('display-none');
		this.mConfigPanel.removeClass('display-block').addClass('display-none');
		this.mStartButton.changeButtonText("Next");
		this.mCancelButton.changeButtonText("Previous");
		this.mRandomButton.addClass('display-none').removeClass('display-block');
	} else if (this.mSecondPanel.hasClass('display-block')) {
		this.mFirstPanel.removeClass('display-block').addClass('display-none');
		this.mSecondPanel.removeClass('display-block').addClass('display-none');
		this.mThirdPanel.removeClass('display-none').addClass('display-block');
		this.mMapPanel.removeClass('display-block').addClass('display-none');
		this.mConfigPanel.removeClass('display-block').addClass('display-none');
		this.mStartButton.changeButtonText("Next");
		this.mCancelButton.changeButtonText("Previous");
		this.mRandomButton.addClass('display-none').removeClass('display-block');
	} else if (this.mThirdPanel.hasClass('display-block')) {
		this.mFirstPanel.removeClass('display-block').addClass('display-none');
		this.mSecondPanel.removeClass('display-block').addClass('display-none');
		this.mThirdPanel.removeClass('display-block').addClass('display-none');
		this.mMapPanel.removeClass('display-none').addClass('display-block');
		this.mConfigPanel.removeClass('display-block').addClass('display-none');
		this.mStartButton.changeButtonText("Next");
		this.mCancelButton.changeButtonText("Previous");
		this.mRandomButton.addClass('display-block').removeClass('display-none');
	} else if (this.mMapPanel.hasClass('display-block')) {
		this.mFirstPanel.removeClass('display-block').addClass('display-none');
		this.mSecondPanel.removeClass('display-block').addClass('display-none');
		this.mThirdPanel.removeClass('display-block').addClass('display-none');
		this.mMapPanel.removeClass('display-block').addClass('display-none');
		this.mConfigPanel.removeClass('display-none').addClass('display-block');
		this.mStartButton.changeButtonText("Start");
		this.mCancelButton.changeButtonText("Previous");
		this.mRandomButton.addClass('display-none').removeClass('display-block');
	} else {
		this.notifyBackendStartButtonPressed();
	}

}

NewCampaignMenuModule.prototype.buildMapConfig = function () {
	var leftColumn = $('<div class="column"></div>');
	this.mMapPanel.append(leftColumn);
	var rightColumn = $('<div class="column"></div>');
	this.mMapPanel.append(rightColumn);

	this.createSliderControlDIV(this.mMapOptions.Width, 'Map Width', leftColumn);
	this.createSliderControlDIV(this.mMapOptions.Height, 'Map Height', leftColumn);
	this.createSliderControlDIV(this.mMapOptions.LandMassMult, 'Land Mass Ratio', leftColumn);
	this.createSliderControlDIV(this.mMapOptions.WaterConnectivity, 'Water', leftColumn);
	//this.createSliderControlDIV(this.mMapOptions.MinLandToWaterRatio, 'Land To Water Ratio', leftColumn);
	this.createSliderControlDIV(this.mMapOptions.Snowline, 'Snowline', leftColumn);
	//this.createSliderControlDIV(this.mMapOptions.MountainsMult, 'Mountain Density', rightColumn);
	//this.createSliderControlDIV(this.mMapOptions.ForestsMult, 'Forest Density', rightColumn);
	//this.createSliderControlDIV(this.mMapOptions.SwampsMult, 'Swamp Density', rightColumn);
	this.createSliderControlDIV(this.mMapOptions.NumSettlements, 'Settlements', rightColumn);
	this.createSliderControlDIV(this.mMapOptions.NumFactions, 'Factions', rightColumn);

	// this.mMapOptions.ForestsMult.Control.addClass('display-none');
	// this.mMapOptions.ForestsMult.Title.addClass('display-none');
	// this.mMapOptions.ForestsMult.Label.addClass('display-none');
	// this.mMapOptions.SwampsMult.Control.addClass('display-none');
	// this.mMapOptions.SwampsMult.Title.addClass('display-none');
	// this.mMapOptions.SwampsMult.Label.addClass('display-none');
	// this.mMapOptions.MountainsMult.Control.addClass('display-none');
	// this.mMapOptions.MountainsMult.Title.addClass('display-none');
	// this.mMapOptions.MountainsMult.Label.addClass('display-none');

	//this.createSliderControlDIV(this.mMapOptions.Vision, 'Vision', rightColumn);

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var title = $('<div class="title title-font-big font-color-title">Map Options</div>');
	row.append(title);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mFogofWarCheckbox = $('<input type="checkbox" id="cb-fog-of-war"/>');
	control.append(this.mFogofWarCheckbox);
	this.mFogofWarCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-fog-of-war">Unexplored Map</label>');
	control.append(this.mFogofWarCheckboxLabel);
	this.mFogofWarCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	if (this.mMapOptions.FOW) {
		this.mFogofWarCheckbox.iCheck('check');
	}

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mStackCitadelsCheckbox = $('<input type="checkbox" id="cb-stackcitadel"/>');
	control.append(this.mStackCitadelsCheckbox);
	this.mStackCitadelsCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-stackcitadel">Decked Out Citadels</label>');
	control.append(this.mStackCitadelsCheckboxLabel);
	this.mStackCitadelsCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	if (this.mMapOptions.StackCitadels) {
		this.mStackCitadelsCheckbox.iCheck('check');
	}

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mAllTradeLocationsCheckbox = $('<input type="checkbox" id="cb-allbuildings"/>');
	control.append(this.mAllTradeLocationsCheckbox);
	this.mAllTradeLocationsCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-allbuildings">All trade buildings available</label>');
	control.append(this.mAllTradeLocationsCheckboxLabel);
	this.mAllTradeLocationsCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	if (this.mMapOptions.AllTradeLocations) {
		this.mAllTradeLocationsCheckbox.iCheck('check');
	}

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mDebugCheckbox = $('<input type="checkbox" id="cb-debug"/>');
	control.append(this.mDebugCheckbox);
	this.mDebugCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-debug">(Debug) Show entire map</label>');
	control.append(this.mDebugCheckboxLabel);
	this.mDebugCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	if (this.mMapOptions.Debug) {
		this.mDebugCheckbox.iCheck('check');
	}
};

NewCampaignMenuModule.prototype.buildConfigPage = function () {
	var leftColumn = $('<div class="column"></div>');
	this.mConfigPanel.append(leftColumn);
	var rightColumn = $('<div class="column"></div>');
	this.mConfigPanel.append(rightColumn);

	var row = $('<div class="row" />');
	leftColumn.append(row);
	var title = $('<div class="title title-font-big font-color-title">Battle Sisters</div>');
	row.append(title);

	var offGenderControl = $('<div class="control"></div>');
	row.append(offGenderControl);
	this.offGenderControlCheckbox = $('<input type="radio" id="cb-gender-off" name="gender-control" />');
	offGenderControl.append(this.offGenderControlCheckbox);
	this.offGenderControlLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-gender-off">Disabled</label>');
	offGenderControl.append(this.offGenderControlLabel);
	this.offGenderControlCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.offGenderControlCheckbox.on('ifChecked', null, this, function (_event) {
		var self = _event.data;
		self.mGenderLevel = 0;
	});

	var lowGenderControl = $('<div class="control"></div>');
	row.append(lowGenderControl);
	this.lowGenderControlCheckbox = $('<input type="radio" id="cb-gender-low" name="gender-control" />');
	lowGenderControl.append(this.lowGenderControlCheckbox);
	this.lowGenderControlLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-gender-low">Specific</label>');
	lowGenderControl.append(this.lowGenderControlLabel);
	this.lowGenderControlCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.lowGenderControlCheckbox.on('ifChecked', null, this, function (_event) {
		var self = _event.data;
		self.mGenderLevel = 1;
	});

	var highGenderControl = $('<div class="control"></div>');
	row.append(highGenderControl);
	this.highGenderControlCheckbox = $('<input type="radio" id="cb-gender-high" name="gender-control" checked />');
	highGenderControl.append(this.highGenderControlCheckbox);
	this.highGenderControlLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-gender-high">All</label>');
	highGenderControl.append(this.highGenderControlLabel);
	this.highGenderControlCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.highGenderControlCheckbox.on('ifChecked', null, this, function (_event) {
		var self = _event.data;
		self.mGenderLevel = 2;
	});


	var row = $('<div class="row"></div>');
	leftColumn.append(row);
	var title = $('<div class="title title-font-big font-color-title">Configuration Options</div>');
	row.append(title);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendPerkTreesCheckbox = $('<input type="checkbox" id="cb-legendperktrees"/>');
	control.append(this.mLegendPerkTreesCheckbox);
	this.mLegendPerkTreesCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendperktrees">Dynamic Perks</label>');
	control.append(this.mLegendPerkTreesCheckboxLabel);
	this.mLegendPerkTreesCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mLegendPerkTreesCheckbox.iCheck('check');

	// var row = $('<div class="row"></div>');
	// leftColumn.append(row);
	// var control = $('<div class="control"/>');
	// row.append(control);
	// this.mLegendGenderEqualityCheckbox = $('<input type="checkbox" id="cb-legendgenderequality"/>');
	// control.append(this.mLegendGenderEqualityCheckbox);
	// this.mLegendGenderEqualityCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendgenderequality">Battle Sisters</label>');
	// control.append(this.mLegendGenderEqualityCheckboxLabel);
	// this.mLegendGenderEqualityCheckbox.iCheck({
	// 	checkboxClass: 'icheckbox_flat-orange',
	// 	radioClass: 'iradio_flat-orange',
	// 	increaseArea: '30%'
	// });
	// this.mLegendGenderEqualityCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	leftColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendArmorCheckbox = $('<input type="checkbox" id="cb-legendarmor"/>');
	control.append(this.mLegendArmorCheckbox);
	this.mLegendArmorCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendarmor">Layered Armor</label>');
	control.append(this.mLegendArmorCheckboxLabel);
	this.mLegendArmorCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mLegendArmorCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	leftColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendItemScalingCheckbox = $('<input type="checkbox" id="cb-legenditemscaling"/>');
	control.append(this.mLegendItemScalingCheckbox);
	this.mLegendItemScalingCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legenditemscaling">Equipment Scaling</label>');
	control.append(this.mLegendItemScalingCheckboxLabel);
	this.mLegendItemScalingCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mLegendItemScalingCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	leftColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendLocationScalingCheckbox = $('<input type="checkbox" id="cb-legendlocationscaling"/>');
	control.append(this.mLegendLocationScalingCheckbox);
	this.mLegendLocationScalingCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendlocationscaling">Distance Scaling</label>');
	control.append(this.mLegendLocationScalingCheckboxLabel);
	this.mLegendLocationScalingCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mLegendLocationScalingCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	leftColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendCampUnlockCheckbox = $('<input type="checkbox" id="cb-legendcampunlock"/>');
	control.append(this.mLegendCampUnlockCheckbox);
	this.mLegendCampUnlockCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendcampunlock">Skip Camp Tutorial</label>');
	control.append(this.mLegendCampUnlockCheckboxLabel);
	this.mLegendCampUnlockCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mLegendCampUnlockCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendRecruitScalingCheckbox = $('<input type="checkbox" id="cb-legendrecruitscaling"/>');
	control.append(this.mLegendRecruitScalingCheckbox);
	this.mLegendRecruitScalingCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendrecruitscaling">Recruit Scaling</label>');
	control.append(this.mLegendRecruitScalingCheckboxLabel);
	this.mLegendRecruitScalingCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
    this.mLegendRecruitScalingCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendBleedKillerCheckbox = $('<input type="checkbox" id="cb-legendbleedkiller"/>');
	control.append(this.mLegendBleedKillerCheckbox);
	this.mLegendBleedKillerCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendbleedkiller">Bleeds Count As Kills</label>');
	control.append(this.mLegendBleedKillerCheckboxLabel);
	this.mLegendBleedKillerCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mLegendBleedKillerCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendWorldEconomyCheckbox = $('<input type="checkbox" id="cb-legendworldeconomy"/>');
	control.append(this.mLegendWorldEconomyCheckbox);
	this.mLegendWorldEconomyCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendworldeconomy">World Economy</label>');
	control.append(this.mLegendWorldEconomyCheckboxLabel);
	this.mLegendWorldEconomyCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.mLegendWorldEconomyCheckbox.iCheck('check');

	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	var control = $('<div class="control"/>');
	row.append(control);
	this.mLegendAllBlueprintsCheckbox = $('<input type="checkbox" id="cb-legendallblueprints"/>');
	control.append(this.mLegendAllBlueprintsCheckbox);
	this.mLegendAllBlueprintsCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendallblueprints">All Crafting Recipes Unlocked</label>');
	control.append(this.mLegendAllBlueprintsCheckboxLabel);
	this.mLegendAllBlueprintsCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});

	// var row = $('<div class="row"></div>');
	// rightColumn.append(row);
	// var control = $('<div class="control"/>');
	// row.append(control);
	// this.mLegendMagicCheckbox = $('<input type="checkbox" id="cb-legendmagic"/>');
	// control.append(this.mLegendMagicCheckbox);
	// this.mLegendMagicCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendmagic">Legend Magic (Experimental)</label>');
	// control.append(this.mLegendMagicCheckboxLabel);
	// this.mLegendMagicCheckbox.iCheck({
	// 	checkboxClass: 'icheckbox_flat-orange',
	// 	radioClass: 'iradio_flat-orange',
	// 	increaseArea: '30%'
	// });

	// var row = $('<div class="row"></div>');
	// rightColumn.append(row);
	// var control = $('<div class="control"/>');
	// row.append(control);
	// this.mLegendTherianCheckbox = $('<input type="checkbox" id="cb-legendrelationship"/>');
	// control.append(this.mLegendTherianCheckbox);
	// this.mLegendTherianCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendrelationship">Relationships</label>');
	// control.append(this.mLegendTherianCheckboxLabel);
	// this.mLegendTherianCheckbox.iCheck({
	// 	checkboxClass: 'icheckbox_flat-orange',
	// 	radioClass: 'iradio_flat-orange',
	// 	increaseArea: '30%'
	// });

	// var row = $('<div class="row"></div>');
	// rightColumn.append(row);
	// var control = $('<div class="control"/>');
	// row.append(control);
	// this.mLegendTherianCheckbox = $('<input type="checkbox" id="cb-legendtherian"/>');
	// control.append(this.mLegendTherianCheckbox);
	// this.mLegendTherianCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-legendtherian">Therianthropy</label>');
	// control.append(this.mLegendTherianCheckboxLabel);
	// this.mLegendTherianCheckbox.iCheck({
	// 	checkboxClass: 'icheckbox_flat-orange',
	// 	radioClass: 'iradio_flat-orange',
	// 	increaseArea: '30%'
	// });


};

NewCampaignMenuModule.prototype.updateMapConfig = function () {
	var controls = [
		this.mMapOptions.Width,
		this.mMapOptions.Height,
		this.mMapOptions.LandMassMult,
		this.mMapOptions.WaterConnectivity,
		this.mMapOptions.Snowline,
		this.mMapOptions.NumSettlements,
		this.mMapOptions.NumFactions
		// this.mMapOptions.ForestsMult,
		// this.mMapOptions.SwampsMult,
		// this.mMapOptions.MountainsMult
	]
	controls.forEach(function (_definition) {
		_definition.Control.attr('min', _definition.Min);
		_definition.Control.attr('max', _definition.Max);
		_definition.Control.attr('step', _definition.Step);
		_definition.Control.val(_definition.Value);
		_definition.Label.text('' + _definition.Value);
	});
	if (this.mMapOptions.FOW) {
		this.mFogofWarCheckbox.iCheck('check');
	}
	if (this.mMapOptions.Debug) {
		this.mDebugCheckbox.iCheck('check');
	}
	if (this.mMapOptions.StackCitadels) {
		this.mStackCitadelsCheckbox.iCheck('check');
	}
	if (this.mMapOptions.AllTradeLocations) {
		this.mAllTradeLocationsCheckbox.iCheck('check');
	}

}

NewCampaignMenuModule.prototype.randomizeMapConfig = function () {

	this.mMapOptions.Width.Value = Helper.getRandomInt(this.mMapOptions.Width.Min, this.mMapOptions.Width.Max);
	this.mMapOptions.Height.Value = Helper.getRandomInt(this.mMapOptions.Height.Min, this.mMapOptions.Height.Max);
	this.mMapOptions.LandMassMult.Value = Helper.getRandomInt(this.mMapOptions.LandMassMult.Min, this.mMapOptions.LandMassMult.Max);
	this.mMapOptions.WaterConnectivity.Value = Helper.getRandomInt(this.mMapOptions.WaterConnectivity.Min, this.mMapOptions.WaterConnectivity.Max);
	this.mMapOptions.Snowline.Value = Helper.weightedRandom(this.mMapOptions.Snowline.Min, this.mMapOptions.Snowline.Max, 90, 5);
	this.mMapOptions.NumSettlements.Value = Helper.getRandomInt(this.mMapOptions.NumSettlements.Min, this.mMapOptions.NumSettlements.Max);
	this.mMapOptions.NumFactions.Value = Helper.getRandomInt(this.mMapOptions.NumFactions.Min, this.mMapOptions.NumFactions.Max);
	this.mMapOptions.ForestsMult.Value = Helper.getRandomInt(this.mMapOptions.ForestsMult.Min, this.mMapOptions.ForestsMult.Max);
	this.mMapOptions.SwampsMult.Value = Helper.getRandomInt(this.mMapOptions.SwampsMult.Min, this.mMapOptions.SwampsMult.Max);
	this.mMapOptions.MountainsMult.Value = Helper.getRandomInt(this.mMapOptions.MountainsMult.Min, this.mMapOptions.MountainsMult.Max);
	this.updateMapConfig();
}

NewCampaignMenuModule.prototype.createSliderControlDIV = function (_definition, _label, _parentDiv) {
	var row = $('<div class="row"></div>');
	_parentDiv.append(row);
	_definition.Title = $('<div class="title title-font-big font-bold font-color-title">' + _label + '</div>');
	row.append(_definition.Title);

	var control = $('<div class="scale-control"></div>');
	row.append(control);

	_definition.Control = $('<input class="scale-slider" type="range"/>');
	_definition.Control.attr('min', _definition.Min);
	_definition.Control.attr('max', _definition.Max);
	_definition.Control.attr('step', _definition.Step);
	_definition.Control.val(_definition.Value);
	control.append(_definition.Control);

	_definition.Label = $('<div class="scale-label text-font-normal font-color-subtitle">' + _definition.Value + '</div>');
	control.append(_definition.Label);

	_definition.Control.on("change", function () {
		_definition.Value = parseInt(_definition.Control.val());
		_definition.Label.text('' + _definition.Value);
	});
};

NewCampaignMenuModule.prototype.bindTooltips = function () {
	this.mCompanyName.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.CompanyName
	});
	this.mSeed.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.Seed
	});

	this.mDifficultyEasyLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyEasy
	});
	this.mDifficultyEasyCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyEasy
	});

	this.mDifficultyNormalLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyNormal
	});
	this.mDifficultyNormalCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyNormal
	});

	this.mDifficultyHardLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyHard
	});
	this.mDifficultyHardCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyHard
	});

	this.mDifficultyLegendaryLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyLegendary
	});
	this.mDifficultyLegendaryCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.DifficultyLegendary
	});


	this.mIronmanCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.Ironman
	});
	this.mIronmanCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.Ironman
	});

	this.mAutosaveCheckboxLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.Autosave });
	this.mAutosaveCheckbox.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.Autosave });


	this.mEconomicDifficultyEasyLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyEasy
	});
	this.mEconomicDifficultyEasyCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyEasy
	});

	this.mEconomicDifficultyNormalLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyNormal
	});
	this.mEconomicDifficultyNormalCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyNormal
	});

	this.mEconomicDifficultyHardLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyHard
	});
	this.mEconomicDifficultyHardCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyHard
	});

	this.mEconomicDifficultyLegendaryLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyLegendary
	});
	this.mEconomicDifficultyLegendaryCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyLegendary
	});


	this.mBudgetDifficultyEasyLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyEasy
	});
	this.mBudgetDifficultyEasyCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyEasy
	});

	this.mBudgetDifficultyNormalLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyNormal
	});
	this.mBudgetDifficultyNormalCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyNormal
	});

	this.mBudgetDifficultyHardLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyHard
	});
	this.mBudgetDifficultyHardCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyHard
	});

	this.mBudgetDifficultyLegendaryLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyLegendary
	});
	this.mBudgetDifficultyLegendaryCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.BudgetDifficultyLegendary
	});


	this.mEvilRandomLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilRandom
	});
	this.mEvilRandomCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilRandom
	});

	/*this.mEvilNoneLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilNone });
	this.mEvilNoneCheckbox.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilNone });*/

	this.mEvilWarLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilWar
	});
	this.mEvilWarCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilWar
	});

	this.mEvilGreenskinsLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilGreenskins
	});
	this.mEvilGreenskinsCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilGreenskins
	});

	this.mEvilUndeadLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilUndead
	});
	this.mEvilUndeadCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilUndead
	});

	this.mEvilPermanentDestructionLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilPermanentDestruction
	});
	this.mEvilPermanentDestructionCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilPermanentDestruction
	});

	this.mMapOptions.Width.Control.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.width'
	});
	this.mMapOptions.Width.Title.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.width'
	});

	this.mMapOptions.Height.Control.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.height'
	});
	this.mMapOptions.Height.Title.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.height'
	});

	this.mMapOptions.LandMassMult.Control.bindTooltip({
	 	contentType: 'ui-element',
		elementId: 'mapconfig.landmass'
	});
	this.mMapOptions.LandMassMult.Title.bindTooltip({
	 	contentType: 'ui-element',
	 	elementId: 'mapconfig.landmass'
	});

	this.mMapOptions.WaterConnectivity.Control.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.water'
	});
	this.mMapOptions.WaterConnectivity.Title.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.water'
	});

	this.mMapOptions.Snowline.Control.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.snowline'
	});
	this.mMapOptions.Snowline.Title.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.snowline'
	});

	// this.mMapOptions.MountainsMult.Control.bindTooltip({ contentType: 'ui-element', elementId: 'mapconfig.mountains' });
	// this.mMapOptions.MountainsMult.Title.bindTooltip({ contentType: 'ui-element', elementId: 'mapconfig.mountains' });

	// this.mMapOptions.ForestsMult.Control.bindTooltip({ contentType: 'ui-element', elementId: 'mapconfig.forest' });
	// this.mMapOptions.ForestsMult.Title.bindTooltip({ contentType: 'ui-element', elementId: 'mapconfig.forest' });

	// this.mMapOptions.SwampsMult.Control.bindTooltip({ contentType: 'ui-element', elementId: 'mapconfig.swamp' });
	// this.mMapOptions.SwampsMult.Title.bindTooltip({ contentType: 'ui-element', elementId: 'mapconfig.swamp' });

	this.mMapOptions.NumSettlements.Control.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.settlements'
	});
	this.mMapOptions.NumSettlements.Title.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.settlements'
	});

	this.mMapOptions.NumFactions.Control.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.factions'
	});
	this.mMapOptions.NumFactions.Title.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.factions'
	});

	this.mFogofWarCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.Exploration
	});
	this.mFogofWarCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.Exploration
	});

	this.mStackCitadelsCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.stackcitadels'
	});
	this.mStackCitadelsCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.stackcitadels'
	});

	this.mAllTradeLocationsCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.alltradelocations'
	});
	this.mAllTradeLocationsCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.alltradelocations'
	});

	this.mLegendPerkTreesCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendperktrees'
	});
	this.mLegendPerkTreesCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendperktrees'
	});

	// this.mLegendGenderEqualityCheckbox.bindTooltip({
	// 	contentType: 'ui-element',
	// 	elementId: 'mapconfig.legendgenderequality'
	// });
	// this.mLegendGenderEqualityCheckboxLabel.bindTooltip({
	// 	contentType: 'ui-element',
	// 	elementId: 'mapconfig.legendgenderequality'
	// });

	this.offGenderControlCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendgenderequality_off'
	});
	this.offGenderControlLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendgenderequality_off'
	});

	this.lowGenderControlCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendgenderequality_low'
	});
	this.lowGenderControlLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendgenderequality_low'
	});

	this.highGenderControlCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendgenderequality_high'
	});
	this.highGenderControlLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendgenderequality_high'
	});


	// this.mLegendMagicCheckbox.bindTooltip({
	// 	contentType: 'ui-element',
	// 	elementId: 'mapconfig.legendmagic'
	// });
	// this.mLegendMagicCheckboxLabel.bindTooltip({
	// 	contentType: 'ui-element',
	// 	elementId: 'mapconfig.legendmagic'
	// });

	this.mLegendArmorCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendarmor'
	});
	this.mLegendArmorCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendarmor'
	});

	this.mDebugCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legenddebug'
	});
	this.mDebugCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legenddebug'
	});

	this.mLegendItemScalingCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legenditemscaling'
	});
	this.mLegendItemScalingCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legenditemscaling'
	});

	this.mLegendLocationScalingCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendlocationscaling'
	});
	this.mLegendLocationScalingCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendlocationscaling'
	});

	this.mLegendCampUnlockCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendcampunlock'
	});
	this.mLegendCampUnlockCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendcampunlock'
	});

	this.mLegendRecruitScalingCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendrecruitscaling'
	});
	this.mLegendRecruitScalingCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendrecruitscaling'
	});

	this.mLegendBleedKillerCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendbleedkiller'
	});
	this.mLegendBleedKillerCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendbleedkiller'
	});

	this.mLegendAllBlueprintsCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendallblueprints'
	});
	this.mLegendAllBlueprintsCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendallblueprints'
	});

	// this.mLegendTherianCheckbox.bindTooltip({
	// 	contentType: 'ui-element',
	// 	elementId: 'mapconfig.legendtherian'
	// });
	// this.mLegendTherianCheckboxLabel.bindTooltip({
	// 	contentType: 'ui-element',
	// 	elementId: 'mapconfig.legendtherian'
	// });

	this.mEvilUndeadLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilUndead });
    this.mEvilUndeadCheckbox.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilUndead });

    this.mEvilCrusadeLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilCrusade });
    this.mEvilCrusadeCheckbox.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EvilCrusade });

	this.mLegendWorldEconomyCheckbox.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendworldeconomy'
	});
	this.mLegendWorldEconomyCheckboxLabel.bindTooltip({
		contentType: 'ui-element',
		elementId: 'mapconfig.legendworldeconomy'
	});

    //this.mExplorationCheckboxLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.Exploration });
    //this.mExplorationCheckbox.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.Exploration });

	this.mEconomicDifficultyEasyLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyEasy });
	this.mEconomicDifficultyEasyCheckbox.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.NewCampaign.EconomicDifficultyEasy });

};

NewCampaignMenuModule.prototype.unbindTooltips = function () {
	this.mCompanyName.unbindTooltip();
	this.mSeed.unbindTooltip();

	this.mDifficultyEasyLabel.unbindTooltip();
	this.mDifficultyEasyCheckbox.unbindTooltip();

	this.mDifficultyNormalLabel.unbindTooltip();
	this.mDifficultyNormalCheckbox.unbindTooltip();

	this.mDifficultyHardLabel.unbindTooltip();
	this.mDifficultyHardCheckbox.unbindTooltip();

	this.mDifficultyLegendaryLabel.unbindTooltip();
	this.mDifficultyLegendaryCheckbox.unbindTooltip();

	this.mEconomicDifficultyEasyLabel.unbindTooltip();
	this.mEconomicDifficultyEasyCheckbox.unbindTooltip();

	this.mEconomicDifficultyNormalLabel.unbindTooltip();
	this.mEconomicDifficultyNormalCheckbox.unbindTooltip();

	this.mEconomicDifficultyHardLabel.unbindTooltip();
	this.mEconomicDifficultyHardCheckbox.unbindTooltip();

	this.mEconomicDifficultyLegendaryLabel.unbindTooltip();
	this.mEconomicDifficultyLegendaryCheckbox.unbindTooltip();


	this.mBudgetDifficultyEasyLabel.unbindTooltip();
	this.mBudgetDifficultyEasyCheckbox.unbindTooltip();

	this.mBudgetDifficultyNormalLabel.unbindTooltip();
	this.mBudgetDifficultyNormalCheckbox.unbindTooltip();

	this.mBudgetDifficultyHardLabel.unbindTooltip();
	this.mBudgetDifficultyHardCheckbox.unbindTooltip();

	this.mBudgetDifficultyLegendaryLabel.unbindTooltip();
	this.mBudgetDifficultyLegendaryCheckbox.unbindTooltip();

	this.mIronmanCheckboxLabel.unbindTooltip();
	this.mIronmanCheckbox.unbindTooltip();

	this.mAutosaveCheckboxLabel.unbindTooltip();
	this.mAutosaveCheckbox.unbindTooltip();

    //this.mExplorationCheckboxLabel.unbindTooltip();
    //this.mExplorationCheckbox.unbindTooltip();

	this.mEvilRandomLabel.unbindTooltip();
	this.mEvilRandomCheckbox.unbindTooltip();

	/*this.mEvilNoneLabel.unbindTooltip();
	this.mEvilNoneCheckbox.unbindTooltip();*/

	this.mEvilWarLabel.unbindTooltip();
	this.mEvilWarCheckbox.unbindTooltip();

	this.mEvilGreenskinsLabel.unbindTooltip();
	this.mEvilGreenskinsCheckbox.unbindTooltip();

	this.mEvilUndeadLabel.unbindTooltip();
    this.mEvilUndeadCheckbox.unbindTooltip();

    this.mEvilCrusadeLabel.unbindTooltip();
    this.mEvilCrusadeCheckbox.unbindTooltip();

	this.mEvilPermanentDestructionLabel.unbindTooltip();
	this.mEvilPermanentDestructionCheckbox.unbindTooltip();

	this.mMapOptions.Width.Control.unbindTooltip();
	this.mMapOptions.Width.Title.unbindTooltip();

	this.mMapOptions.Height.Control.unbindTooltip();
	this.mMapOptions.Height.Title.unbindTooltip();

	// this.mMapOptions.LandMassMult.Control.unbindTooltip();
	// this.mMapOptions.LandMassMult.Title.unbindTooltip();

	this.mMapOptions.WaterConnectivity.Control.unbindTooltip();
	this.mMapOptions.WaterConnectivity.Title.unbindTooltip();

	this.mMapOptions.Snowline.Control.unbindTooltip();
	this.mMapOptions.Snowline.Title.unbindTooltip();

	// this.mMapOptions.MountainsMult.Control.unbindTooltip();
	// this.mMapOptions.MountainsMult.Title.unbindTooltip();

	// this.mMapOptions.ForestsMult.Control.unbindTooltip();
	// this.mMapOptions.ForestsMult.Title.unbindTooltip();

	// this.mMapOptions.SwampsMult.Control.unbindTooltip();
	// this.mMapOptions.SwampsMult.Title.unbindTooltip();

	this.mMapOptions.NumSettlements.Control.unbindTooltip();
	this.mMapOptions.NumSettlements.Title.unbindTooltip();

	this.mMapOptions.NumFactions.Control.unbindTooltip();
	this.mMapOptions.NumFactions.Title.unbindTooltip();

	this.mFogofWarCheckbox.unbindTooltip();
	this.mFogofWarCheckboxLabel.unbindTooltip();

	this.mStackCitadelsCheckbox.unbindTooltip();
	this.mStackCitadelsCheckboxLabel.unbindTooltip();

	this.mAllTradeLocationsCheckbox.unbindTooltip();
	this.mAllTradeLocationsCheckboxLabel.unbindTooltip();

	this.mLegendPerkTreesCheckbox.unbindTooltip();
	this.mLegendPerkTreesCheckboxLabel.unbindTooltip();

	// this.mLegendGenderEqualityCheckbox.unbindTooltip();
	// this.mLegendGenderEqualityCheckboxLabel.unbindTooltip();


	this.offGenderControlCheckbox.unbindTooltip();
	this.offGenderControlLabel.unbindTooltip();

	this.lowGenderControlCheckbox.unbindTooltip();
	this.lowGenderControlLabel.unbindTooltip();

	this.highGenderControlCheckbox.unbindTooltip();
	this.highGenderControlLabel.unbindTooltip();

	// this.mLegendMagicCheckbox.unbindTooltip();
	// this.mLegendMagicCheckboxLabel.unbindTooltip();

	this.mLegendArmorCheckbox.unbindTooltip();
	this.mLegendArmorCheckboxLabel.unbindTooltip();

	this.mDebugCheckbox.unbindTooltip();
	this.mDebugCheckboxLabel.unbindTooltip();

	this.mLegendItemScalingCheckbox.unbindTooltip();
	this.mLegendItemScalingCheckboxLabel.unbindTooltip();

	this.mLegendLocationScalingCheckbox.unbindTooltip();
	this.mLegendLocationScalingCheckboxLabel.unbindTooltip();

	this.mLegendCampUnlockCheckbox.unbindTooltip();
	this.mLegendCampUnlockCheckboxLabel.unbindTooltip();

	this.mLegendRecruitScalingCheckbox.unbindTooltip();
	this.mLegendRecruitScalingCheckboxLabel.unbindTooltip();

	this.mLegendBleedKillerCheckbox.unbindTooltip();
	this.mLegendBleedKillerCheckboxLabel.unbindTooltip();

	this.mLegendAllBlueprintsCheckbox.unbindTooltip();
	this.mLegendAllBlueprintsCheckboxLabel.unbindTooltip();

	// this.mLegendTherianCheckbox.unbindTooltip();
	// this.mLegendTherianCheckboxLabel.unbindTooltip();
};


NewCampaignMenuModule.prototype.create = function (_parentDiv) {
	this.createDIV(_parentDiv);
	this.bindTooltips();
};

NewCampaignMenuModule.prototype.destroy = function () {
	this.unbindTooltips();
	this.destroyDIV();
};


NewCampaignMenuModule.prototype.register = function (_parentDiv) {
	console.log('NewCampaignMenuModule::REGISTER');

	if (this.mContainer !== null) {
		console.error('ERROR: Failed to register New Campaign Menu Module. Reason: New Campaign Menu Module is already initialized.');
		return;
	}

	if (_parentDiv !== null && typeof (_parentDiv) == 'object') {
		this.create(_parentDiv);
	}
};

NewCampaignMenuModule.prototype.unregister = function () {
	console.log('NewCampaignMenuModule::UNREGISTER');

	if (this.mContainer === null) {
		console.error('ERROR: Failed to unregister New Campaign Menu Module. Reason: New Campaign Menu Module is not initialized.');
		return;
	}

	this.destroy();
};

NewCampaignMenuModule.prototype.isRegistered = function () {
	if (this.mContainer !== null) {
		return this.mContainer.parent().length !== 0;
	}

	return false;
};


NewCampaignMenuModule.prototype.registerEventListener = function (_listener) {
	this.mEventListener = _listener;
};


NewCampaignMenuModule.prototype.show = function () {
	// reseed
	//this.mSeed.setInputText(Math.round(Math.random() * 9999999).toString(16));

	var seed = "";
	var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	for (var i = 0; i < 10; i++)
		seed += characters.charAt(Math.floor(Math.random() * characters.length));

	this.mSeed.setInputText(seed);

	// reset panels
	this.mFirstPanel.addClass('display-block').removeClass('display-none');
	this.mSecondPanel.removeClass('display-block').addClass('display-none');
	this.mThirdPanel.removeClass('display-block').addClass('display-none');
	this.mMapPanel.removeClass('display-block').addClass('display-none');
	this.mConfigPanel.removeClass('display-block').addClass('display-none');
	this.mStartButton.changeButtonText("Next");
	this.mCancelButton.changeButtonText("Cancel");
	this.mRandomButton.removeClass('display-block').addClass('display-none');

	var self = this;

	var offset = -(this.mContainer.parent().width() + this.mContainer.width());
	this.mContainer.css({
		'left': offset
	});
	this.mContainer.velocity("finish", true).velocity({
		opacity: 1,
		left: '0',
		right: '0'
	}, {
		duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
		easing: 'swing',
		begin: function () {
			$(this).removeClass('display-none').addClass('display-block');
			self.notifyBackendModuleAnimating();
		},
		complete: function () {
			self.mIsVisible = true;
			self.notifyBackendModuleShown();
		}
	});
};

NewCampaignMenuModule.prototype.hide = function () {
	var self = this;

	var offset = -(this.mContainer.parent().width() + this.mContainer.width());
	this.mContainer.velocity("finish", true).velocity({
		opacity: 0,
		left: offset
	}, {
		duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
		easing: 'swing',
		begin: function () {
			self.notifyBackendModuleAnimating();
		},
		complete: function () {
			self.mIsVisible = false;
			$(this).removeClass('display-block').addClass('display-none');
			self.notifyBackendModuleHidden();
		}
	});
};

NewCampaignMenuModule.prototype.isVisible = function () {
	return this.mIsVisible;
};


NewCampaignMenuModule.prototype.onPreviousBannerClicked = function () {
	--this.mCurrentBannerIndex;

	if (this.mCurrentBannerIndex < 0)
		this.mCurrentBannerIndex = this.mBanners.length - 1;

	this.mBannerImage.attr('src', Path.GFX + 'ui/banners/' + this.mBanners[this.mCurrentBannerIndex] + '.png');
};


NewCampaignMenuModule.prototype.onNextBannerClicked = function () {
	++this.mCurrentBannerIndex;

	if (this.mCurrentBannerIndex >= this.mBanners.length)
		this.mCurrentBannerIndex = 0;

	this.mBannerImage.attr('src', Path.GFX + 'ui/banners/' + this.mBanners[this.mCurrentBannerIndex] + '.png');
};


NewCampaignMenuModule.prototype.setBanners = function (_data) {
	if (_data !== null && jQuery.isArray(_data)) {
		this.mBanners = _data;
		this.mCurrentBannerIndex = Math.floor(Math.random() * _data.length);

		this.mBannerImage.attr('src', Path.GFX + 'ui/banners/' + _data[this.mCurrentBannerIndex] + '.png');
	} else {
		console.error('ERROR: No banners specified for NewCampaignMenu::setBanners');
	}
}


NewCampaignMenuModule.prototype.setStartingScenarios = function (_data) {
	if (_data !== null && jQuery.isArray(_data)) {
		this.mScenarios = _data;
		this.mScenarioScrollContainer.empty();

		for (var i = 0; i < _data.length; ++i) {
			this.addStartingScenario(i, _data[i], this.mScenarioScrollContainer);
		}
	}
}

NewCampaignMenuModule.prototype.setCrusadeCampaignVisible = function (_data)
{
    if(_data)
    {
        this.mEvilCrusadeControl.addClass('display-block').removeClass('display-none');
    }
    else
    {
        this.mEvilCrusadeControl.removeClass('display-block').addClass('display-none');
    }
}

NewCampaignMenuModule.prototype.addStartingScenario = function (_index, _data, _row)
{
    var self = this;

	var control = $('<div class="control"></div>');
	_row.append(control);

	var radioButton = $('<input type="radio" id="cb-scenario-' + _index + '" name="scenario" ' + (_index == 0 ? 'checked' : '') + '/>');
	control.append(radioButton);

	var label = $('<label class="text-font-normal font-color-subtitle" for="cb-scenario-' + _index + '">' + _data.Name + '</label>');
	control.append(label);

	label.bindTooltip({
		contentType: 'ui-element',
		elementId: TooltipIdentifier.MenuScreen.NewCampaign.StartingScenario
	});

	radioButton.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});

	radioButton.on('ifChecked', null, this, function (_event) {
		var self = _event.data;
		self.mSelectedScenario = _index;
		self.updateStartingScenarioDescription(_data.Description, _data.Difficulty);
	});

	if (_index == 0)
		this.updateStartingScenarioDescription(_data.Description, _data.Difficulty);
}


NewCampaignMenuModule.prototype.updateStartingScenarioDescription = function (_desc, _difficulty) {
	var parsedText = XBBCODE.process({
		text: _desc,
		removeMisalignedTags: false,
		addInLineBreaks: true
	});

	this.mScenariosDesc.html(parsedText.html);
	this.mScenariosDifficulty.attr('src', Path.GFX + 'ui/images/' + _difficulty + '.png');
};

NewCampaignMenuModule.prototype.setConfigOpts = function (_data) {
	if (_data !== null) {
		this.mMapConfigOpts = _data;

		if ('Height' in _data) {
			this.mMapOptions.Height.Value = _data['Height'];
			this.mMapOptions.Height.Min = _data['HeightMin'];
			this.mMapOptions.Height.Max = _data['HeightMax'];
		}
		if ('Width' in _data) {
			this.mMapOptions.Width.Value = _data['Width'];
			this.mMapOptions.Width.Min = _data['WidthMin'];
			this.mMapOptions.Width.Max = _data['WidthMax'];
		}
		if ('LandMassMult' in _data) {
			this.mMapOptions.LandMassMult.Value = _data['LandMassMult'];
			this.mMapOptions.LandMassMult.Min = _data['LandMassMultMin'];
			this.mMapOptions.LandMassMult.Max = _data['LandMassMultMax'];
		}
		if ('WaterConnectivity' in _data) {
			this.mMapOptions.WaterConnectivity.Value = _data['WaterConnectivity'];
			this.mMapOptions.WaterConnectivity.Min = _data['WaterConnectivityMin'];
			this.mMapOptions.WaterConnectivity.Max = _data['WaterConnectivityMax'];
		}
		if ('MinLandToWaterRatio' in _data) {
			this.mMapOptions.MinLandToWaterRatio.Value = _data['MinLandToWaterRatio'];
			this.mMapOptions.MinLandToWaterRatio.Min = _data['MinLandToWaterRatioMin'];
			this.mMapOptions.MinLandToWaterRatio.Max = _data['MinLandToWaterRatioMax'];
		}
		if ('Snowline' in _data) {
			this.mMapOptions.Snowline.Value = _data['Snowline'];
			this.mMapOptions.Snowline.Min = _data['SnowlineMin'];
			this.mMapOptions.Snowline.Max = _data['SnowlineMax'];
		}
		if ('NumSettlements' in _data) {
			this.mMapOptions.NumSettlements.Value = _data['NumSettlements'];
			this.mMapOptions.NumSettlements.Min = _data['NumSettlementsMin'];
			this.mMapOptions.NumSettlements.Max = _data['NumSettlementsMax'];
		}
		if ('NumFactions' in _data) {
			this.mMapOptions.NumFactions.Value = _data['NumFactions'];
			this.mMapOptions.NumFactions.Min = _data['NumFactionsMin'];
			this.mMapOptions.NumFactions.Max = _data['NumFactionsMax'];
		}
		if ('ForestsMult' in _data) {
			this.mMapOptions.ForestsMult.Value = _data['ForestsMult'];
			this.mMapOptions.ForestsMult.Min = _data['ForestsMultMin'];
			this.mMapOptions.ForestsMult.Max = _data['ForestsMultMax'];
		}
		if ('SwampsMult' in _data) {
			this.mMapOptions.SwampsMult.Value = _data['SwampsMult'];
			this.mMapOptions.SwampsMult.Min = _data['SwampsMultMin'];
			this.mMapOptions.SwampsMult.Max = _data['SwampsMultMax'];
		}
		if ('MountainsMult' in _data) {
			this.mMapOptions.MountainsMult.Value = _data['MountainsMult'];
			this.mMapOptions.MountainsMult.Min = _data['MountainsMultMin'];
			this.mMapOptions.MountainsMult.Max = _data['MountainsMultMax'];
		}
		if ('FOW' in _data) {
			this.mMapOptions.FOW = _data['FOW'];
		}
		if ('Debug' in _data) {
			this.mMapOptions.Debug = _data['Debug'];
		}
		if ('StackCitadels' in _data) {
			this.mMapOptions.StackCitadels = _data['StackCitadels'];
		}
		if ('AllTradeLocations' in _data) {
			this.mMapOptions.AllTradeLocations = _data['AllTradeLocations'];
		}
	} else {
		console.error('ERROR: No opts specified for NewCampaignMenu::setConfigOpts');
	}
	this.updateMapConfig();
}


NewCampaignMenuModule.prototype.collectSettings = function () {
	var settings = [];

	// company name
	settings.push(this.mCompanyName.getInputText());

	// banner
	settings.push(this.mBanners[this.mCurrentBannerIndex]);

	// difficulty
	settings.push(this.mDifficulty);
	settings.push(this.mEconomicDifficulty);
	settings.push(this.mBudgetDifficulty);
    settings.push(this.mIronmanCheckbox.is(':checked'));
	settings.push(this.mEvil);
	settings.push(this.mEvilPermanentDestructionCheckbox.is(':checked'));
	settings.push(this.mSeed.getInputText());
	settings.push(this.mMapOptions.Width.Value);
	settings.push(this.mMapOptions.Height.Value);
	settings.push(this.mMapOptions.LandMassMult.Value);
	settings.push(this.mMapOptions.WaterConnectivity.Value);
	settings.push(this.mMapOptions.MinLandToWaterRatio.Value);
	settings.push(this.mMapOptions.Snowline.Value);
	settings.push(this.mMapOptions.NumSettlements.Value);
	settings.push(this.mMapOptions.NumFactions.Value);
	//settings.push(this.mExplorationCheckbox.is(':checked'));
	settings.push(this.mFogofWarCheckbox.is(':checked'));
	settings.push(this.mMapOptions.ForestsMult.Value);
	settings.push(this.mMapOptions.SwampsMult.Value);
	settings.push(this.mMapOptions.MountainsMult.Value);
	settings.push(this.mStackCitadelsCheckbox.is(':checked'));
	settings.push(this.mAllTradeLocationsCheckbox.is(':checked'));
	settings.push(this.mScenarios[this.mSelectedScenario].ID);
	settings.push(this.mLegendPerkTreesCheckbox.is(":checked"));
	//settings.push(this.mLegendGenderEqualityCheckbox.is(":checked"));
	settings.push(this.mGenderLevel);
	settings.push(false);//settings.push(this.mLegendMagicCheckbox.is(":checked"));
	settings.push(this.mLegendArmorCheckbox.is(":checked"));
	settings.push(this.mDebugCheckbox.is(":checked"));
	settings.push(this.mAutosaveCheckbox.is(':checked'));
	settings.push(this.mLegendItemScalingCheckbox.is(":checked"));
	settings.push(this.mLegendLocationScalingCheckbox.is(":checked"));
	settings.push(this.mLegendCampUnlockCheckbox.is(":checked"));
	settings.push(this.mLegendRecruitScalingCheckbox.is(":checked"));
	settings.push(this.mLegendBleedKillerCheckbox.is(":checked"));
	settings.push(this.mLegendAllBlueprintsCheckbox.is(":checked"));
	settings.push(false); //settings.push(this.mLegendRelationshipCheckbox.is(":checked"));
	settings.push(this.mLegendWorldEconomyCheckbox.is(":checked"));
	settings.push(false);//settings.push(this.mLegendTherianCheckbox.is(":checked"));

	return settings;
}


NewCampaignMenuModule.prototype.notifyBackendModuleShown = function () {
	if (this.mSQHandle !== null) {
		SQ.call(this.mSQHandle, 'onModuleShown');
	}
};

NewCampaignMenuModule.prototype.notifyBackendModuleHidden = function () {
	if (this.mSQHandle !== null) {
		SQ.call(this.mSQHandle, 'onModuleHidden');
	}
};

NewCampaignMenuModule.prototype.notifyBackendModuleAnimating = function () {
	if (this.mSQHandle !== null) {
		SQ.call(this.mSQHandle, 'onModuleAnimating');
	}
};

NewCampaignMenuModule.prototype.notifyBackendStartButtonPressed = function () {
	if (this.mSQHandle !== null) {
		var settings = this.collectSettings();
		SQ.call(this.mSQHandle, 'onStartButtonPressed', settings);
	}
};

NewCampaignMenuModule.prototype.notifyBackendCancelButtonPressed = function () {
	if (this.mSQHandle !== null) {
		SQ.call(this.mSQHandle, 'onCancelButtonPressed');
	}
};