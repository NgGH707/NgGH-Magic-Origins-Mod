/*
var ws_character_screen_paperdoll_module_onBrotherSelected = CharacterScreenPaperdollModule.prototype.onBrotherSelected;
CharacterScreenPaperdollModule.prototype.onBrotherSelected = function (
	_dataSource,
	_brother
) {
	ws_character_screen_paperdoll_module_onBrotherSelected.call(this, _dataSource, _brother);

	if (_brother !== null && CharacterScreenIdentifier.Paperdoll.Equipment in _brother && 'BlockedSlots' in _brother[CharacterScreenIdentifier.Paperdoll.Equipment]) {
		for (var i = 0; i < _brother[CharacterScreenIdentifier.Paperdoll.Equipment].BlockedSlots.length; i++) {
			var slot = this.getSlot(_brother[CharacterScreenIdentifier.Paperdoll.Equipment].BlockedSlots[i]);
			var isSmall = _brother[CharacterScreenIdentifier.Paperdoll.Equipment].BlockedSlots[i] >= 3;
			var image = isSmall ? 'missing_component_70x70.png' : 'missing_component_140x70.png';
			slot.Container.assignPaperdollItemImage(
				Path.ITEMS + image,
				false,
				false
			);
		}
	}
};
*/

var ws_character_screen_paperdoll_module_assignEquipment = CharacterScreenPaperdollModule.prototype.assignEquipment;
CharacterScreenPaperdollModule.prototype.assignEquipment = function (
	_brotherId,
	_data
) {
	ws_character_screen_paperdoll_module_assignEquipment.call(this, _brotherId, _data);

	if ('BlockedSlots' in _data) {
		for (var i = 0; i < _data.BlockedSlots.length; i++) {
			var slot = this.getSlot(_data.BlockedSlots[i]);
			var isSmall = _data.BlockedSlots[i] >= 3;
			var image = isSmall ? 'missing_component_70x70.png' : 'missing_component_140x70.png';
			slot.Container.assignPaperdollItemImage(
				Path.ITEMS + image,
				false,
				false
			);
		}
	}
};

CharacterScreenPaperdollModule.prototype.getSlot = function( _type )
{
	switch(_type)
	{
	case 0:
		return this.mLeftEquipmentSlots.RightHand;

	case 1:
		return this.mRightEquipmentSlots.LeftHand;

	case 2:
		return this.mMiddleEquipmentSlots.Body;

	case 3:
		return this.mMiddleEquipmentSlots.Head;

	case 4:
		return this.mLeftEquipmentSlots.Accessory;

	default:
		return this.mRightEquipmentSlots.Ammo;
	}
}
