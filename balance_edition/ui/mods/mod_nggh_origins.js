// OVERWRITTEN FUNCTIONS --------------------------------------------------------------------------------------------------------------------


// refresh origin pool
var ws_setStartingScenarios = NewCampaignMenuModule.prototype.setStartingScenarios
NewCampaignMenuModule.prototype.setStartingScenarios = function(_data)
{
	if (_data !== null && jQuery.isArray(_data)) {
		this.mScenarioScrollContainer.empty();
		ws_setStartingScenarios.call(this, _data);
	}
};


// show a huge red X on the slot if the slot can't be used

CharacterScreenPaperdollModule.prototype.blockThisSlot = function (_slot, _imagePath) {
  _slot.Container.assignPaperdollItemImage(Path.ITEMS + _imagePath, false, false);
  _slot.Container.assignPaperdollItemOverlayImage();
  _slot.Container.setPaperdollRepairImageVisible(false);
};

CharacterScreenPaperdollModule.prototype.assignBlockSlots = function (
  _data
) {
	if (_data[CharacterScreenIdentifier.ItemSlot.Mainhand])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.RightHand, _data['IconLarge']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Offhand])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.LeftHand, _data['IconLarge']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Head])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Head, _data['Icon']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Body])
	{
		this.blockThisSlot(this.mMiddleEquipmentSlots.Body, _data['IconLarge']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Accessory])
	{
		this.blockThisSlot(this.mLeftEquipmentSlots.Accessory, _data['Icon']);
	}
	
	if (_data[CharacterScreenIdentifier.ItemSlot.Ammo])
	{
		this.blockThisSlot(this.mRightEquipmentSlots.Ammo, _data['Icon']);
	}
};

//var ws_onBrotherSelected = CharacterScreenPaperdollModule.prototype.onBrotherSelected
//CharacterScreenPaperdollModule.prototype.onBrotherSelected = function (
//  _dataSource,
//  _brother
//) {
//	ws_onBrotherSelected.call(this, _dataSource, _brother);
//};

var ws_onBrotherUpdated = CharacterScreenPaperdollModule.prototype.onBrotherUpdated
CharacterScreenPaperdollModule.prototype.onBrotherUpdated = function (
  _dataSource,
  _brother
) {
  ws_onBrotherUpdated.call(this, _dataSource, _brother);

  if (_brother !== null && CharacterScreenIdentifier.Entity.Id in _brother) {
		if ('restriction' in _brother && _brother['restriction'] !== undefined && _brother['restriction'] !== null) {
       this.assignBlockSlots(
        _brother['restriction']
      );
    }
	}
};

