this.nggh_mod_named_accessory <- ::inherit("scripts/items/accessory/accessory", {
	m = {
		PrefixList = ::Const.Strings.LegendCatNames,
		SuffixList = [],
		NameList = [],
		DefaultName = "",
		UseRandomName = true

		SpecialValue = 0,
		DamageMult = 1.0,
		ArmorDamageMult = 1.0,
		Initiative = 0,
		Bravery = 0
	},
	function create()
	{
		this.accessory.create();
		this.m.ItemType = this.m.ItemType | ::Const.Items.ItemType.Named;
		this.randomizeValues();
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		if (this.m.DamageMult > 1.0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (::Math.floor(this.m.DamageMult * 100) - 100) + "%[/color] Damage to Hitpoints"
			});
		}

		if (this.m.ArmorDamageMult > 1.0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (::Math.floor(this.m.ArmorDamageMult * 100) - 100) + "%[/color] Damage to Armor"
			});
		}

		if (this.m.Initiative != 0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.Initiative + "[/color] Initiative"
			});
		}

		if (this.m.Bravery != 0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + this.m.Bravery + "[/color] Resolve"
			});
		}

		return result;
	}

	function getRandomCharacterName( _list )
	{
		local vars = [
			[
				"randomname",
				::MSU.Array.rand(::Const.Strings.CharacterNames)
			],
			[
				"randomsouthernname",
				::MSU.Array.rand(::Const.Strings.SouthernNames)
			],
			[
				"randomtown",
				::MSU.Array.rand(::Const.World.LocationNames.VillageWestern)
			]
		];
		return this.buildTextFromTemplate(::MSU.Array.rand(_list), vars);
	}

	function createRandomName()
	{
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

	function onEquip()
	{
		this.accessory.onEquip();

		if (this.m.Name.len() == 0)
		{
			if (::Math.rand(1, 100) <= 50)
			{
				this.setName(this.getContainer().getActor().getName());
			}
			else
			{
				this.m.DefaultName = "";
				this.setName(this.createRandomName());
			}
		}
	}

	function onAddedToStash( _stashID )
	{
		if (this.m.Name.len() == 0)
		{
			this.m.DefaultName = "";
			this.setName(this.createRandomName());
		}
	}

	function setName( _name )
	{
		if (this.m.DefaultName.len() != 0)
		{
			this.m.Name = _name + "\'s " +  this.m.DefaultName;
			return;
		}

		this.m.Name = _name;
	}

	function randomizeValues()
	{
		this.m.SpecialValue = ::Math.round(this.m.SpecialValue * ::Math.rand(100, 150) * 0.01);

		local available = [];

		if (this.m.StaminaModifier <= -1)
		{
			available.push(function ( _i )
			{
				_i.m.StaminaModifier = ::Math.min(0, _i.m.StaminaModifier + ::Math.rand(0, 3));
			});
		}

		if (this.m.DamageMult > 1.0)
		{
			available.push(function ( _i )
			{
				_i.m.DamageMult = ::Math.round(_i.m.DamageMult * ::Math.rand(100, 140)) * 0.01;
			});
		}

		if (this.m.ArmorDamageMult > 1.0)
		{
			available.push(function ( _i )
			{
				_i.m.ArmorDamageMult = ::Math.round(_i.m.ArmorDamageMult * ::Math.rand(100, 140)) * 0.01;
			});
		}

		if (this.m.Initiative > 0)
		{
			available.push(function ( _i )
			{
				_i.m.Initiative = ::Math.round(_i.m.Initiative * ::Math.rand(100, 150) * 0.01);
			});
		}

		if (this.m.Bravery > 0)
		{
			available.push(function ( _i )
			{
				_i.m.Bravery = ::Math.round(_i.m.Bravery * ::Math.rand(100, 150) * 0.01);
			});
		}

		local total = this.m.SpecialValue != 0 ? 1 : 2;
		for( local n = total; n != 0 && available.len() != 0; --n )
		{
			local r = ::Math.rand(0, available.len() - 1);
			available[r](this);
			available.remove(r);
		}
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.DamageRegularMult *= this.m.DamageMult;
		_properties.DamageArmorMult *= this.m.ArmorDamageMult;
		_properties.Initiative += this.m.Initiative;
		_properties.Bravery += this.m.Bravery;
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeI8(this.m.StaminaModifier);
		_out.writeI16(this.m.SpecialValue);
		_out.writeF32(this.m.DamageMult);
		_out.writeF32(this.m.ArmorDamageMult);
		_out.writeI16(this.m.Initiative);
		_out.writeI16(this.m.Bravery);
		this.accessory.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Name = _in.readString();
		this.m.StaminaModifier = _in.readI8();
		this.m.SpecialValue = _in.readI16();
		this.m.DamageMult = _in.readF32();
		this.m.ArmorDamageMult = _in.readF32();
		this.m.Initiative = _in.readI16();
		this.m.Bravery = _in.readI16();
		this.accessory.onDeserialize(_in);
	}

});

