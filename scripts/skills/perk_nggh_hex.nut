this.perk_nggh_hex <- ::inherit("scripts/skills/perk_nggh_unique", {
	m = {
		ColorName = "",
		Color = ::createColor("#ff0000"),
		HexType = ::Const.Hex.Type.Default,
	},
	function create()
	{
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		this.perk_nggh_unique.onAdded();

		local hex = this.getContainer().getSkillByID("spells.hex");

		if (hex == null) return;

		this.onUpgradeHex(hex);
	}

	function onRemoved()
	{
		this.perk_nggh_unique.onRemoved();
		
		local hex = this.getContainer().getSkillByID("spells.hex");

		if (hex == null) return;

		hex.onResetHex();
	}

	function onUpgradeHex( _hex )
	{
		_hex.m.Name = this.m.Name;
		_hex.m.Icon = "skills/active_hex_" + this.m.ColorName + ".png";
		_hex.m.Overlay = "active_hex_" + this.m.ColorName;
		_hex.m.HasFixedColor = true;
		_hex.m.Color = this.m.Color;

		if (_hex.m.PerkIDsToQuery.find(this.m.ID) == null)
		{
			_hex.m.PerkIDsToQuery.push(this.m.ID);
		}
		
		this.addAdditionalTooltips(_hex, true);
	}

	function onHex( _targetEntity, _masterHex, _slaveHex )
	{
		foreach (s in _masterHex.getSlave())
		{
			if (s == null || s.isNull())
			{
				continue;
			}

			this.applyHex(_targetEntity, s);
		}

		_masterHex.m.HexType = this.m.HexType;
		_masterHex.m.Icon = "skills/status_effect_hex_" + this.m.ColorName + ".png";
		_masterHex.m.IconMini = "status_effect_hex_" + this.m.ColorName + "_mini";
	}

	function onAfterHex( _targetEntity, _masterHex, _slaveHex )
	{
	}

	function applyHex( _targetEntity, _slaveHex )
	{
		_slaveHex.m.Name = this.m.Name;
		_slaveHex.m.HexType = this.m.HexType;
		_slaveHex.m.Icon = "skills/status_effect_hex_" + this.m.ColorName + ".png";
		_slaveHex.m.IconMini = "status_effect_hex_" + this.m.ColorName + "_mini";

		this.addAdditionalTooltips(_slaveHex);
	}

	function addAdditionalTooltips( _hex, _addTitle = false )
	{
		if (_addTitle)
		{
			_hex.m.AdditionalTooltips.push({
				id = 3,
				type = "text",
				text = "[u][size=14]" + this.m.Name + "[/size][/u]"
			});
		}

		_hex.m.AdditionalTooltips.extend(this.getAdditionalTooltips());
	}

	function getAdditionalTooltips()
	{
		return [];
	}

});

