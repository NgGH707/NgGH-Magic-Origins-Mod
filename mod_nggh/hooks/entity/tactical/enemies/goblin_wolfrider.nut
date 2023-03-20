::mods_hookExactClass("entity/tactical/enemies/goblin_wolfrider", function (obj) 
{
	local ws_assignRandomEquipment = obj.assignRandomEquipment;
    obj.assignRandomEquipment = function()
	{
		ws_assignRandomEquipment()
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Body));
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Head));

		local armors = ["goblin_medium","goblin_medium","goblin_medium","goblin_heavy"];
		local helmets = ["goblin_light","goblin_heavy"];

		if (::Legends.Mod.ModSettings.getSetting("UnlayeredArmor").getValue())
		{
			this.m.Items.equip(::new("scripts/items/armor/greenskins/" + ::MSU.Array.rand(armors) + "_armor"));
			this.m.Items.equip(::new("scripts/items/helmets/greenskins/" + ::MSU.Array.rand(helmets) + "_helmet"));
		}
		else
		{
			this.m.Items.equip(::new("scripts/items/legend_armor/greenskins/nggh_mod_" + ::MSU.Array.rand(armors) + "_armor"));
			this.m.Items.equip(::new("scripts/items/legend_helmets/greenskins/nggh_mod_" + ::MSU.Array.rand(helmets) + "_helmet"));
		}
	}

	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss");
		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand));
		this.m.Items.equip(::new("scripts/items/weapons/named/" + ::MSU.Array.rand(["named_goblin_falchion","named_goblin_spear"])));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_legend_hair_splitter"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_relentless"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nine_lives"));
		return true;
	}

	obj.spawnWolf = function( _info )
	{
		::Sound.play(::MSU.Array.rand(this.m.Sound[::Const.Sound.ActorEvent.DamageReceived]), ::Const.Sound.Volume.Actor * this.m.SoundVolume[::Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
		local entity = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/wolf", _info.Tile.Coords.X, _info.Tile.Coords.Y);

		if (entity != null)
		{
			entity.setVariant(this.m.Variant, _info.WolfColor, _info.WolfSaturation, 0.45);
			entity.setFaction(_info.Faction);
			entity.setMoraleState(_info.Morale);

			if (this.m.IsMiniboss)
			{
				entity.makeMiniboss();
				entity.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
				entity.m.Skills.add(::new("scripts/skills/perks/perk_legend_hair_splitter"));
			}
		}
	}

	obj.spawnGoblin = function( _info )
	{
		::Sound.play(::MSU.Array.rand(this.m.Sound[::Const.Sound.ActorEvent.Other1]), ::Const.Sound.Volume.Actor * this.m.SoundVolume[::Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
		local entity = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/goblin_fighter", _info.Tile.Coords.X, _info.Tile.Coords.Y);

		if (entity != null)
		{
			if (this.m.IsMiniboss)
			{
				entity.makeMiniboss();
				entity.m.Items.clear();
				entity.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
				entity.m.Skills.add(::new("scripts/skills/perks/perk_legend_hair_splitter"));
			}

			local newBody = entity.getSprite("body");
			newBody.setBrush(_info.Body);
			newBody.Color = _info.Color;
			newBody.Saturation = _info.Saturation;
			local newHead = entity.getSprite("head");
			newHead.setBrush(_info.Head);
			newHead.Color = _info.Color;
			newHead.Saturation = _info.Saturation;
			entity.setFaction(_info.Faction);
			entity.getItems().clear();
			this.m.Items.transferTo(entity.getItems());
			entity.setMoraleState(_info.Morale);
			entity.setHitpoints(entity.getHitpointsMax() * 0.45);
			entity.onUpdateInjuryLayer();
		}
	}
});