this.nggh_mod_named_armor_upgrade <- ::inherit("scripts/items/armor_upgrades/armor_upgrade", {
	m = {
		PrefixList = ::Const.Strings.RandomArmorPrefix,
		SuffixList = [],
		NameList = [],
		DefaultName = "",
		UseRandomName = true,
		SpecialValue = 0,
	},

	function create()
	{
		this.armor_upgrade.create();
		this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.Named;
		this.m.IsDroppedAsLoot = true;
	}

	function getRandomCharacterName( _list )
	{
		return ::MSU.Array.rand(_list);
	}

	function createRandomName()
	{
		if (this.m.NameList.len() == 0) return null;

		if (!this.m.UseRandomName || ::Math.rand(1, 100) <= 60)
		{
			if (this.m.SuffixList.len() == 0 || ::Math.rand(1, 100) <= 70)
			{
				return ::MSU.Array.rand(this.m.PrefixList) + " " + ::MSU.Array.rand(this.m.NameList);
			}
			else
			{
				return ::MSU.Array.rand(this.m.NameList) + " " + ::MSU.Array.rand(this.m.SuffixList);
			}
		}
		else if (::Math.rand(1, 2) == 1)
		{
			return this.getRandomCharacterName(::Const.Strings.KnightNames) + "\'s " + ::MSU.Array.rand(this.m.NameList);
		}
		else
		{
			return this.getRandomCharacterName(::Const.Strings.BanditLeaderNames) + "\'s " + ::MSU.Array.rand(this.m.NameList);
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
		if (_name == null)
		{
			this.m.Name = this.m.DefaultName;
			return;
		}

		if (this.m.DefaultName.len() != 0)
		{
			this.m.Name = _name + "\'s " +  this.m.DefaultName;
			return;
		}

		this.m.Name = _name;
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = ::Math.min(0, this.m.StaminaModifier + ::Math.rand(0, 3));
		this.m.ConditionModifier = ::Math.floor(this.m.ConditionModifier * ::Math.rand(115, 140) * 0.01) * 1.0;
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

