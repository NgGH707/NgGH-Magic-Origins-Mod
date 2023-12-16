this.mod_nggh_named_schrat_shield <- ::inherit("scripts/items/shields/named/named_shield", {
	m = {},
	function create()
	{
		this.named_shield.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "shield.named_schrat";
		this.m.NameList = ["Shield","Protector","Board","Wall","Cover","Bark","Guardian","Defender","Barricade","Barrier","Bastion","Fortress","Guard","Rampart","Keeper","Warden","Carapace"];
		this.m.Description = "This shield was used by a living tree to defend against your attacks. A great trophy from a great battle, and is also a bit lighter for its size. By holding it on your hand, you somehow feel safe and calm.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 3500;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -13;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.randomizeValues();
	}

	function createRandomName()
	{
		return ::MSU.Array.rand(::Const.Strings.SchratNames);
	}

	function setName( _name )
	{
		this.m.Name = _name + "\'s " + ::MSU.Array.rand(this.m.NameList);
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_schrat_shield_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_schrat_shield_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "bust_schrat_shield_0" + this.m.Variant + "_dead";
		this.m.IconLarge = "shields/inventory_named_schrat_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_named_schrat_shield_0" + this.m.Variant + ".png";
	}

	function getTooltip()
	{
		local result = this.named_shield.getTooltip();

		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]33%[/color] less damage from piercing attacks."
		});

		return result;
	}

	function onEquip()
	{
		if (this.m.Name.len() == 0)
			this.setName(this.createRandomName());

		this.named_shield.onEquip();
		this.addSkill(::new("scripts/skills/actives/shieldwall"));
		this.addSkill(::new("scripts/skills/actives/knock_back"));
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null)
			return;

		switch (_hitInfo.DamageType)
		{
			case ::Const.Damage.DamageType.Piercing:
				_properties.DamageReceivedRegularMult *= 0.67; 
				break;

			//case ::Const.Damage.DamageType.Burning:
				//_properties.DamageReceivedRegularMult *= 1.33;
				//break;
		}
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
	}

});

