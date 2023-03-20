var ws_turnsequencebar_module = Screens.TacticalScreen.getModule("TurnSequenceBarModule");
ws_turnsequencebar_module.mCenterContainer = null;
ws_turnsequencebar_module.mLeftContainer = null;
ws_turnsequencebar_module.mMountColumn = null;
//ws_turnsequencebar_module.mMagicColumn = null;
//ws_turnsequencebar_module.mShowMagicStats = false;
ws_turnsequencebar_module.mShowMountStats = false;
ws_turnsequencebar_module.mLastShowMount = false;
ws_turnsequencebar_module.mHasShowExtraStats = false;
ws_turnsequencebar_module.mMountStatsRows =
{
    ArmorHead:
    {
        ImagePath: Path.GFX + Asset.ICON_ARMOR_HEAD,
        StyleName: ProgressbarStyleIdentifier.ArmorHead,
        TooltipId: TooltipIdentifier.CharacterStats.ArmorHead,
        Row: null,
        Progressbar: null,
        ProgressbarPreview: null,
        ProgressbarLabel: null,
    },
    ArmorBody:
    {
        ImagePath: Path.GFX + Asset.ICON_ARMOR_BODY,
        StyleName: ProgressbarStyleIdentifier.ArmorBody,
        TooltipId: TooltipIdentifier.CharacterStats.ArmorBody,
        Row: null,
        Progressbar: null,
        ProgressbarPreview: null,
        ProgressbarLabel: null,
    },
    Hitpoints:
    {
        ImagePath: Path.GFX + Asset.ICON_HEALTH,
        StyleName: ProgressbarStyleIdentifier.Hitpoints,
        TooltipId: TooltipIdentifier.CharacterStats.Hitpoints,
        Row: null,
        Progressbar: null,
        ProgressbarPreview: null,
        ProgressbarLabel: null,
    }
};
/*
ws_turnsequencebar_module.mMagicStatsRows =
{
    MagicPoints:
    {
        ImagePath: Path.GFX + 'ui/icons/magic_point.png',
        StyleName: 'magic-points',
        TooltipId: TooltipIdentifier.CharacterStats.Hitpoints,
        Row: null,
        Progressbar: null,
        ProgressbarPreview: null,
        ProgressbarLabel: null,
    }
};
*/

TacticalScreenTurnSequenceBarModule.prototype.create_hook_turnsequencebar_Div = function ()
{
    // small tweaks
    this.mCenterContainer = this.mContainer.find('.l-center-container:first');
    this.mLeftContainer = this.mCenterContainer.find('.left-container:first');
    this.mStatsContainer.css('background-size', '100% 15.1rem');

    //var firstColumn = this.mStatsContainer.find('.stats-column:first');
    //this.mMagicColumn = $('<div class="l-extra-stats-column display-none"/>');
    //firstColumn.append(this.mMagicColumn);

    this.mMountColumn = $('<div class="stats-column display-none"/>');
    this.mStatsContainer.append(this.mMountColumn);
    var statsValuesColumnMountLayout = $('<div class="l-stats-column"/>');
    this.mMountColumn.append(statsValuesColumnMountLayout);

    // create: stats values rows
    //this.createStatsRowDIV(this.mMagicStatsRows, this.mMagicColumn);
    this.createStatsRowDIV(this.mMountStatsRows, statsValuesColumnMountLayout);
}

// HOOKS
/*
var ws_TacticalScreenTurnSequenceBarModule_showStatsPanel = TacticalScreenTurnSequenceBarModule.prototype.showStatsPanel;
TacticalScreenTurnSequenceBarModule.prototype.showStatsPanel = function(_show, _instant)
{
    this.mHasShowExtraStats = false;

    if (_show) {
        this.mLeftStatsRows.Morale.Row.showThisDiv(!this.mShowMagicStats);
        this.mMagicColumn.showThisDiv(this.mShowMagicStats);

        if (this.mLastShowMount != this.mShowMountStats) {
            this.mCenterContainer.css('width', this.mShowMountStats ? '120.0rem' : '100.0rem');
            this.mLeftContainer.css('width', this.mShowMountStats ? '60.0rem' : '40.0rem');
            this.mStatsContainer.css('width', this.mShowMountStats ? '61.0rem' : '41.0rem');
            this.mMountColumn.showThisDiv(this.mShowMountStats);
            this.mLastShowMount = this.mShowMountStats;
        }

        this.mHasShowExtraStats = this.mShowMagicStats || this.mShowMountStats;
    }

    ws_TacticalScreenTurnSequenceBarModule_showStatsPanel.call(this, _show, _instant);
}
*/

var ws_TacticalScreenTurnSequenceBarModule_updateStatsPanel = TacticalScreenTurnSequenceBarModule.prototype.updateStatsPanel;
TacticalScreenTurnSequenceBarModule.prototype.updateStatsPanel = function(_data)
{
    if (_data === null || typeof(_data) != 'object')
        return;

    //this.mShowMagicStats = 'MagicPoints' in _data;
    this.mShowMountStats = 'MountHitpoints' in _data;
    ws_TacticalScreenTurnSequenceBarModule_updateStatsPanel.call(this, _data);
    // update magic points
    var newWidth = 0;
    /*if ('MagicPoints' in _data && 'MagicPointsMax' in _data) {
        newWidth = 0;
        if (_data.MagicPointsMax > 0) {
            newWidth = (_data.MagicPoints * 100) / _data.MagicPointsMax;
            newWidth = Math.max(Math.min(newWidth, 100), 0);
        }
        this.mMagicStatsRows.MagicPoints.Progressbar.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMagicStatsRows.MagicPoints.ProgressbarPreview.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMagicStatsRows.MagicPoints.ProgressbarLabel.html(_data.MagicPoints + ' / ' + _data.MagicPointsMax);
    }

    // update magic points preview
    if ('MagicPointsPreview' in _data && 'MagicPointsMaxPreview' in _data) {
        newWidth = 0;
        if (_data.MagicPointsMaxPreview > 0) {
            newWidth = (_data.MagicPointsPreview * 100) / _data.MagicPointsMaxPreview;
            newWidth = Math.max(Math.min(newWidth, 100), 0);
        }
        this.mMagicStatsRows.MagicPoints.ProgressbarPreview.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMagicStatsRows.MagicPoints.ProgressbarLabel.html(_data.MagicPointsPreview + ' / ' + _data.MagicPointsMaxPreview);
    }*/

    // update mount hit points
    if ('MountHitpoints' in _data && 'MountHitpointsMax' in _data) {
        newWidth = 0;
        if (_data.MountHitpointsMax > 0) {
            newWidth = (_data.MountHitpoints * 100) / _data.MountHitpointsMax;
            newWidth = Math.max(Math.min(newWidth, 100), 0);
        }
        this.mMountStatsRows.Hitpoints.Progressbar.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMountStatsRows.Hitpoints.ProgressbarPreview.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMountStatsRows.Hitpoints.ProgressbarLabel.html(_data.MountHitpoints + ' / ' + _data.MountHitpointsMax);
    }

    // update mount armor head
    if ('MountArmorHead' in _data && 'MountArmorHeadMax' in _data) {
        newWidth = 0;
        if (_data.MountArmorHeadMax > 0) {
            newWidth = (_data.MountArmorHead * 100) / _data.MountArmorHeadMax;
            newWidth = Math.max(Math.min(newWidth, 100), 0);
        }
        this.mMountStatsRows.ArmorHead.Progressbar.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMountStatsRows.ArmorHead.ProgressbarPreview.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMountStatsRows.ArmorHead.ProgressbarLabel.html(_data.MountArmorHead + ' / ' + _data.MountArmorHeadMax);
    }

    // update mount armor body
    if ('MountArmorBody' in _data && 'MountArmorBodyMax' in _data) {
        newWidth = 0;
        if (_data.MountArmorBodyMax > 0) {
            newWidth = (_data.MountArmorBody * 100) / _data.MountArmorBodyMax;
            newWidth = Math.max(Math.min(newWidth, 100), 0);

        }
        this.mMountStatsRows.ArmorBody.Progressbar.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMountStatsRows.ArmorBody.ProgressbarPreview.velocity("stop", true).velocity({ 'width': newWidth + '%' }, { duration: this.mProgressbarMovementDuration });
        this.mMountStatsRows.ArmorBody.ProgressbarLabel.html(_data.MountArmorBody + ' / ' + _data.MountArmorBodyMax);
    }
}

var ws_TacticalScreenTurnSequenceBarModule_bindTooltips = TacticalScreenTurnSequenceBarModule.prototype.bindTooltips;
TacticalScreenTurnSequenceBarModule.prototype.bindTooltips = function()
{
    ws_TacticalScreenTurnSequenceBarModule_bindTooltips.call(this);

    /*$.each(this.mMagicStatsRows, function(_key, _value) {
        _value.Row.bindTooltip({ contentType: 'ui-element', elementId: _value.TooltipId });
    });*/
    $.each(this.mMountStatsRows, function(_key, _value) {
        _value.Row.bindTooltip({ contentType: 'ui-element', elementId: _value.TooltipId });
    });
}

var ws_TacticalScreenTurnSequenceBarModule_createDIV = TacticalScreenTurnSequenceBarModule.prototype.createDIV;
TacticalScreenTurnSequenceBarModule.prototype.createDIV = function(_parentDiv)
{
    ws_TacticalScreenTurnSequenceBarModule_createDIV.call(this, _parentDiv);
    this.create_hook_turnsequencebar_Div();
}





