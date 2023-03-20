::mods_hookExactClass("entity/tactical/enemies/legend_hexe_leader", function ( obj )
{
	obj.getNachoAppearance <- function()
	{
		if (!::World.Flags.get("IsLuftAdventure"))
		{
			return null;
		}

		local r = ::Math.rand(1, 4);
		local noDress = ::Math.rand(1, 2) == 1;
		local ret = [];
		ret.push(r == 1 ? "bust_ghoulskin_head_01" : "bust_ghoulskin_0" + r + "_head_0" + ::Math.rand(1, 3));
		ret.push((noDress ? "bust_boobas_ghoul_body_0" : "bust_boobas_ghoul_with_dress_0") + r);
		return ret;
	}

	obj.setCharming = function( _f )
	{
		if (_f == this.m.IsCharming)
		{
			return;
		}

		this.m.IsCharming = _f;
		local t = 300;

		if (this.m.IsCharming)
		{
			local a = this.getNachoAppearance();
			local sprite;

			if (a != null)
			{
				sprite = this.getSprite("charm_body");
				sprite.setBrush(a[1]);
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_head");
				sprite.setBrush(a[0]);
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_armor");
				sprite.resetBrush();
				sprite = this.getSprite("charm_hair");
				sprite.resetBrush();
			}
			else 
			{
				sprite = this.getSprite("charm_body");
				sprite.setBrush("bust_hexen_charmed_body_01");
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_armor");
				sprite.setBrush("bust_hexen_charmed_dress_0" + ::Math.rand(1, 3));
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_head");
				sprite.setBrush("bust_hexen_charmed_head_0" + ::Math.rand(1, 2));
				sprite.Visible = true;
				sprite.fadeIn(t);
				sprite = this.getSprite("charm_hair");
				sprite.setBrush("bust_hexen_charmed_hair_0" + ::Math.rand(1, 5));
				sprite.Visible = true;
				sprite.fadeIn(t);
			}

			sprite = this.getSprite("body");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("head");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("hair");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("injury");
			sprite.fadeOutAndHide(t);
			::Time.scheduleEvent(::TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}

				local sprite;
				sprite = _e.getSprite("body");
				sprite.Visible = false;
				sprite = _e.getSprite("head");
				sprite.Visible = false;
				sprite = _e.getSprite("hair");
				sprite.Visible = false;
				sprite = _e.getSprite("injury");
				sprite.Visible = false;
				_e.setDirty(true);
			}, this);
		}
		else
		{
			local sprite;
			sprite = this.getSprite("charm_body");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("charm_armor");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("charm_head");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("charm_hair");
			sprite.fadeOutAndHide(t);
			sprite = this.getSprite("body");
			sprite.Visible = true;
			sprite.fadeIn(t);
			sprite = this.getSprite("head");
			sprite.Visible = true;
			sprite.fadeIn(t);
			sprite = this.getSprite("hair");
			sprite.Visible = true;
			sprite.fadeIn(t);
			sprite = this.getSprite("injury");
			sprite.fadeIn(t);
			this.onUpdateInjuryLayer();
			::Time.scheduleEvent(::TimeUnit.Virtual, t + 100, function ( _e )
			{
				if (!_e.isAlive())
				{
					return;
				}

				local sprite;
				sprite = _e.getSprite("charm_body");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_armor");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_head");
				sprite.Visible = false;
				sprite = _e.getSprite("charm_hair");
				sprite.Visible = false;
				_e.setDirty(true);
			}, this);
		}

		local effect = {
			Delay = 0,
			Quantity = 50,
			LifeTimeQuantity = 50,
			SpawnRate = 1000,
			Brushes = [
				"effect_heart_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("fff3e50f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 0.5,
					ScaleMax = 0.5,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-0.5, 0.0),
					DirectionMax = ::createVec(0.5, 1.0),
					SpawnOffsetMin = ::createVec(-30, -70),
					SpawnOffsetMax = ::createVec(30, 30),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("fff3e500"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-0.5, 0.0),
					DirectionMax = ::createVec(0.5, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		::Tactical.spawnParticleEffect(false, effect.Brushes, this.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}
	obj.makeMiniboss <- function()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		local b = this.m.BaseProperties;
		
		if (b.getMeleeSkill() < 60)
		{
			b.MeleeSkill = 60;
		}

		if (b.getRangedSkill() < 75)
		{
			b.RangedSkill = 75;
		}

		this.m.Items.unequip(this.m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand));
		this.m.Items.equip(::new("scripts/items/weapons/named/nggh_mod_named_staff"));
		this.m.Items.equip(::new("scripts/items/accessory/legend_white_wolf_item"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(::new("scripts/skills/actives/insects_skill"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));

		local rune = ::new("scripts/skills/rune_sigils/nggh_mod_RSH_shielding");
		rune.m.IsForceEnabled = true;
		rune.m.HitpointsThreshold = 100;
		this.m.Skills.add(rune);
		rune.m.Hitpoints = 100;
		rune.m.HitpointsMax = 150;

		if("Assets" in ::World && ::World.Assets != null && ::World.Assets.getCombatDifficulty() == ::Const.Difficulty.Legendary)
		{
			rune.m.Hitpoints = 150;
			rune.m.HitpointsMax = 250;
		}

		local AI = this.getAIAgent();
		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_bow"));
		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_throw_net"));
		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_miasma"));
		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_raise_undead"));
		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_swarm_of_insects"));
		AI.removeBehavior(::Const.AI.Behavior.ID.Darkflight);

		local lightning = ::new("scripts/skills/actives/lightning_storm_skill");
		lightning.m.ActionPointCost = 1;
		lightning.m.Cooldown = 0;
		this.m.Skills.add(lightning);
		AI.addBehavior(::new("scripts/ai/tactical/behaviors/ai_lightning_storm"));
		return true;
	};
});