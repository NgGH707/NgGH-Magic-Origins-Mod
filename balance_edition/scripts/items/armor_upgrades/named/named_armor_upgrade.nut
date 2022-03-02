this.named_armor_upgrade <- this.inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {
		PrefixList = this.Const.Strings.RandomArmorPrefix,
		SuffixList = [],
		NameList = [],
		DefaultName = "",
		UseRandomName = true,
		SpecialValue = 0,
	},

	function create()
	{
		this.armor_upgrade.create();
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Named;
		this.m.IsDroppedAsLoot = true;
	}

	function getRandomCharacterName( _list )
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomsouthernname",
				this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(_list[this.Math.rand(0, _list.len() - 1)], vars);
	}

	function createRandomName()
	{
		if (!this.m.UseRandomName || this.Math.rand(1, 100) <= 60)
		{
			if (this.m.SuffixList.len() == 0 || this.Math.rand(1, 100) <= 70)
			{
				return this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)] + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
			}
			else
			{
				return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
			}
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			return this.getRandomCharacterName(this.Const.Strings.KnightNames) + "\'s " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
		else
		{
			return this.getRandomCharacterName(this.Const.Strings.BanditLeaderNames) + "\'s " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
	}

	function onAddedToStash( _stashID )
	{
		if (this.m.Name.len() == 0)
		{
			this.setName(this.createRandomName());
		}
	}

	function setName( _name )
	{
		this.m.Name = _name + "\'s " +  this.m.DefaultName;
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = this.Math.min(0, this.m.StaminaModifier + this.Math.rand(0, 3));
		this.m.ConditionModifier = this.Math.floor(this.m.ConditionModifier * this.Math.rand(115, 140) * 0.01) * 1.0;
	}

	function onAdded()
	{
		this.m.PreviousCondition = this.m.Armor.m.ConditionMax;
		this.m.PreviousStamina = this.m.Armor.m.StaminaModifier;
		this.m.Armor.m.ConditionMax += this.m.ConditionModifier;
		this.m.Armor.m.Condition += this.m.ConditionModifier;
		this.m.Armor.m.StaminaModifier += this.m.StaminaModifier;
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeF32(this.m.ConditionModifier);
		_out.writeI16(this.m.StaminaModifier);
		_out.writeI16(this.m.SpecialValue);
		this.armor_upgrade.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Name = _in.readString();
		this.m.ConditionModifier = _in.readF32();
		this.m.StaminaModifier = _in.readI16();
		this.m.SpecialValue = _in.readI16();
		this.armor_upgrade.onDeserialize(_in);
	}

});

