this.getroottable().HexenHooks.hookActorAndEntity <- function ()
{
	//make charmed dogs on retreating would add themselves as loot
	::mods_hookBaseClass("entity/tactical/actor", function (obj)
	{
		obj = obj[obj.SuperName];
		local ws_retreat = obj.retreat;
		obj.retreat = function ()
		{
			local s = this.m.Skills.getSkillByID("effects.charmed_pet");

			if (s != null)
			{
				this.logInfo("Charmed pet is retreating");
				s.onAddPetToLoot();
			}

			ws_retreat();
		}
	});

	// XD :lol_goblin:
	::mods_hookExactClass("entity/tactical/enemies/hexe", function ( obj )
	{
		obj.getNachoAppearance <- function()
		{
			if (!this.World.Flags.get("IsLuftAdventure"))
			{
				return null;
			}

			local r = this.Math.rand(1, 4);
			local noDress = this.Math.rand(1, 2) == 1;
			local ret = [];
			ret.push(r == 1 ? "bust_ghoulskin_head_01" : "bust_ghoulskin_0" + r + "_head_0" + this.Math.rand(1, 3));
			ret.push((noDress ? "bust_boobas_ghoul_body_0" : "bust_boobas_ghoul_with_dress_0") + r);
			return ret;
		}

		::mods_override(obj, "setCharming", function( _f )
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
					sprite.setBrush("bust_hexen_charmed_dress_0" + this.Math.rand(1, 3));
					sprite.Visible = true;
					sprite.fadeIn(t);
					sprite = this.getSprite("charm_head");
					sprite.setBrush("bust_hexen_charmed_head_0" + this.Math.rand(1, 2));
					sprite.Visible = true;
					sprite.fadeIn(t);
					sprite = this.getSprite("charm_hair");
					sprite.setBrush("bust_hexen_charmed_hair_0" + this.Math.rand(1, 5));
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
				this.Time.scheduleEvent(this.TimeUnit.Virtual, t + 100, function ( _e )
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
				this.Time.scheduleEvent(this.TimeUnit.Virtual, t + 100, function ( _e )
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
						ColorMin = this.createColor("fff3e50f"),
						ColorMax = this.createColor("ffffff5f"),
						ScaleMin = 0.5,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, 0.0),
						DirectionMax = this.createVec(0.5, 1.0),
						SpawnOffsetMin = this.createVec(-30, -70),
						SpawnOffsetMax = this.createVec(30, 30),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = this.createColor("fff3e500"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, 0.0),
						DirectionMax = this.createVec(0.5, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, this.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		});
	});

	::mods_hookExactClass("entity/tactical/enemies/legend_hexe_leader", function ( obj )
	{
		obj.getNachoAppearance <- function()
		{
			if (!this.World.Flags.get("IsLuftAdventure"))
			{
				return null;
			}

			local r = this.Math.rand(1, 4);
			local noDress = this.Math.rand(1, 2) == 1;
			local ret = [];
			ret.push(r == 1 ? "bust_ghoulskin_head_01" : "bust_ghoulskin_0" + r + "_head_0" + this.Math.rand(1, 3));
			ret.push((noDress ? "bust_boobas_ghoul_body_0" : "bust_boobas_ghoul_with_dress_0") + r);
			return ret;
		}

		::mods_override(obj, "setCharming", function( _f )
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
					sprite.setBrush("bust_hexen_charmed_dress_0" + this.Math.rand(1, 3));
					sprite.Visible = true;
					sprite.fadeIn(t);
					sprite = this.getSprite("charm_head");
					sprite.setBrush("bust_hexen_charmed_head_0" + this.Math.rand(1, 2));
					sprite.Visible = true;
					sprite.fadeIn(t);
					sprite = this.getSprite("charm_hair");
					sprite.setBrush("bust_hexen_charmed_hair_0" + this.Math.rand(1, 5));
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
				this.Time.scheduleEvent(this.TimeUnit.Virtual, t + 100, function ( _e )
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
				this.Time.scheduleEvent(this.TimeUnit.Virtual, t + 100, function ( _e )
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
						ColorMin = this.createColor("fff3e50f"),
						ColorMax = this.createColor("ffffff5f"),
						ScaleMin = 0.5,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, 0.0),
						DirectionMax = this.createVec(0.5, 1.0),
						SpawnOffsetMin = this.createVec(-30, -70),
						SpawnOffsetMax = this.createVec(30, 30),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = this.createColor("fff3e500"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, 0.0),
						DirectionMax = this.createVec(0.5, 1.0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, this.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		});
	});

	if (!this.IsAccessoryCompanionsExist)
	{
		//Add variant of warwolf to wolf_item
		::mods_hookExactClass("entity/tactical/warwolf", function ( obj )
		{
			obj.setVariant <- function( _v )
			{
				this.m.Items.getAppearance().Body = "bust_wolf_0" + _v;
				this.getSprite("body").setBrush("bust_wolf_0" + _v + "_body");
				this.getSprite("head").setBrush("bust_wolf_0" + _v + "_head");
				this.setDirty(true);
			}
		});

		//Make wolf_item have an actual right icon for it wolf variant
		::mods_hookExactClass("items/accessory/wolf_item", function(obj) 
		{
		    obj.setEntity <- function( _e )
			{
				this.m.Entity = _e;

				if (this.m.Variant > 2)
				{
					this.m.Variant = this.Math.rand(1, 2);
				}

				local variant = this.m.Variant == 1 ? 2 : 1;

				if (this.m.Entity != null)
				{
					this.m.Icon = "tools/dog_01_leash_70x70.png";
				}
				else
				{
					this.m.Icon = "tools/wolf_0" + variant + "_70x70.png";
				}
			}
		});
	}

	//change equipment for goblins
	::mods_hookExactClass("entity/tactical/enemies/goblin_ambusher", function (obj) {
	    obj.assignRandomEquipment = function()
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local r = this.Math.rand(1, 2);

				if (r == 1 || !this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 60)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_heavy_bow"));
				}
				else if (r == 2)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_bow"));
				}
			}

			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_notched_blade"));

			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + "goblin_skirmisher" + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + "goblin_skirmisher" + pre2 + "_helmet"));
			}

			if (this.Math.rand(1, 100) <= 10)
			{
				this.m.Items.addToBag(this.new("scripts/items/accessory/poison_item"));
			}

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				this.m.Items.addToBag(this.new("scripts/items/accessory/poison_item"));
			}
		}
	});
	::mods_hookExactClass("entity/tactical/enemies/goblin_ambusher_low", function (obj) {
	    obj.assignRandomEquipment = function()
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_bow"));
			}

			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
			this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_notched_blade"));

			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + "goblin_skirmisher" + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + "goblin_skirmisher" + pre2 + "_helmet"));
			}
		}
	});


	::mods_hookExactClass("entity/tactical/enemies/goblin_fighter", function (obj) {
	    obj.assignRandomEquipment = function ()
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local weapons = [
					"weapons/greenskins/goblin_falchion",
					"weapons/greenskins/goblin_spear",
					"weapons/legend_chain",
					"weapons/greenskins/goblin_notched_blade"
				];

				if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Offhand))
				{
					weapons.extend([
						"weapons/greenskins/goblin_pike"
					]);
				}

				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getID() != "weapon.goblin_spear" && this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getID() != "weapon.named_goblin_spear")
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
			}

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
			}

			if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Offhand))
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					this.m.Items.equip(this.new("scripts/items/tools/throwing_net"));
				}
				else
				{
					local shields = [
						"shields/greenskins/goblin_light_shield",
						"shields/greenskins/goblin_heavy_shield"
					];
					this.m.Items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
				}
			}

			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				local armors = [
					"goblin_light",
					"goblin_medium",
					"goblin_heavy",
				]; 
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + armors[this.Math.rand(0, armors.len() - 1)] + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				local helmets = [
					"goblin_light",
					"goblin_light",
					"goblin_light",
					"goblin_heavy",
				]; 
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + helmets[this.Math.rand(0, helmets.len() - 1)] + pre2 + "_helmet"));
			}
		}
	});
	::mods_hookExactClass("entity/tactical/enemies/goblin_fighter_low", function (obj) {
	    obj.assignRandomEquipment = function ()
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local weapons = [
					"weapons/greenskins/goblin_falchion",
					"weapons/greenskins/goblin_spear",
					"weapons/legend_chain",
					"weapons/greenskins/goblin_notched_blade"
				];

				if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Offhand))
				{
					weapons.extend([
						"weapons/greenskins/goblin_pike"
					]);
				}

				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getID() != "weapon.goblin_spear" && this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getID() != "weapon.named_goblin_spear")
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
			}

			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
			}

			if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Offhand))
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					this.m.Items.equip(this.new("scripts/items/tools/throwing_net"));
				}
				else
				{
					this.m.Items.equip(this.new("scripts/items/" + "shields/greenskins/goblin_light_shield"));
				}
			}

			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				local armors = [
					"goblin_light",
					"goblin_medium",
				]; 
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + armors[this.Math.rand(0, armors.len() - 1)] + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				local helmets = [
					"goblin_light",
					"goblin_light",
					"goblin_light",
				]; 
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + helmets[this.Math.rand(0, helmets.len() - 1)] + pre2 + "_helmet"));
			}
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/goblin_wolfrider", function (obj) {
	    obj.assignRandomEquipment = function()
		{
			local r;
			r = this.Math.rand(1, 2);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_spear"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_falchion"));
			}

			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				local armors = [
					"goblin_medium",
					"goblin_medium",
					"goblin_medium",
					"goblin_heavy",
				]; 
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + armors[this.Math.rand(0, armors.len() - 1)] + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				local helmets = [
					"goblin_light",
					"goblin_light",
					"goblin_light",
					"goblin_heavy",
				]; 
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + helmets[this.Math.rand(0, helmets.len() - 1)] + pre2 + "_helmet"));
			}
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/goblin_leader", function (obj) {
	    obj.assignRandomEquipment = function()
		{
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_crossbow"));
			this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_falchion"));

			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + "goblin_leader" + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + "goblin_leader" + pre2 + "_helmet"));
			}
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/goblin_shaman", function (obj) {
	    obj.assignRandomEquipment = function()
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greenskins/goblin_staff"));
			
			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null)
			{
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + "goblin_shaman" + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + "goblin_shaman" + pre2 + "_helmet"));
			}
		}
	});

	//change equipment for orcs
	::mods_hookExactClass("entity/tactical/enemies/legend_orc_behemoth", function (obj) {
		obj.assignRandomEquipment = function()
		{
			local r;
			r = this.Math.rand(1, 4);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_limb_lopper"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_bough"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_man_mangler"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skullbreaker"));
			}

			local item = this.Const.World.Common.pickHelmet([
				[
					1,
					"greenskins/legend_orc_behemoth_helmet"
				]
			]);

			if (item != null)
			{
				this.m.Items.equip(item);
			}

			local armor = this.LegendsMod.Configs().LegendArmorsEnabled() ? "layer_greenskins/legend_orc_behemoth_base_armor" : "greenskins/legend_orc_behemoth_armor";
			this.m.Items.equip(this.new("scripts/items/armor/" + armor));
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/legend_orc_elite", function (obj) {
		obj.assignRandomEquipment = function()
		{
			local r;

			if (this.Math.rand(1, 100) <= 15)
			{
				r = this.Math.rand(1, 2);

				if (r == 1)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/named/named_orc_cleaver"));
				}
				else if (r == 2)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/named/named_orc_axe"));
				}
			}
			else
			{
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skullsmasher"));
				}
				else if (r == 2)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe"));
				}
				else if (r == 3)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_cleaver"));
				}
				else if (r == 4)
				{
					this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skin_flayer"));
				}
			}

			if (this.Math.rand(1, 100) <= 2)
			{
				this.m.Items.equip(this.new("scripts/items/shields/named/named_orc_heavy_shield"));
			}
			else
			{
				this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_heavy_shield"));
			}

			local item = this.Const.World.Common.pickHelmet([
				[
					1,
					"greenskins/orc_elite_heavy_helmet"
				]
			]);

			if (item != null)
			{
				this.m.Items.equip(item);
			}

			local armor = this.LegendsMod.Configs().LegendArmorsEnabled() ? "layer_greenskins/orc_elite_heavy_base_armor" : "greenskins/orc_elite_heavy_armor";
			this.m.Items.equip(this.new("scripts/items/armor/" + armor));
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/orc_berserker", function (obj) {
		obj.assignRandomEquipment = function()
		{
			local r = this.Math.rand(1, 8);

			if (r == 1)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe"));
			}
			else if (r == 2)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_cleaver"));
			}
			else if (r == 3)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_flail_2h"));
			}
			else if (r == 4)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/orc_axe_2h"));
			}
			else if (r == 5)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_limb_lopper"));
			}
			else if (r == 6)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_man_mangler"));
			}
			else if (r == 7)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_bough"));
			}
			else if (r == 8)
			{
				this.m.Items.equip(this.new("scripts/items/weapons/greenskins/legend_skullbreaker"));
			}

			local pre1 = "greenskins/";
			local pre2 = "";

			if (this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				pre1 = "layer_greenskins/";
				pre2 = "_base";
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Body) == null && this.Math.rand(1, 5) <= 2)
			{
				local armors = [
					"orc_berserker_light",
					"orc_berserker_medium",
				]; 
				this.m.Items.equip(this.new("scripts/items/armor/" + pre1 + armors[this.Math.rand(0, armors.len() - 1)] + pre2 + "_armor"));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null && this.Math.rand(1, 3) == 2)
			{
				local helmet = "orc_berserker";
				this.m.Items.equip(this.new("scripts/items/helmets/" + pre1 + helmet + pre2 + "_helmet"));
			}
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/orc_warlord", function (obj) {
		obj.assignRandomEquipment = function()
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local weapons = [
					"weapons/greenskins/orc_axe",
					"weapons/greenskins/orc_cleaver"
				];

				if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
				{
					weapons.extend([
						"weapons/greenskins/orc_axe_2h",
						"weapons/greenskins/orc_axe_2h"
					]);
				}

				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}

			local armor = this.LegendsMod.Configs().LegendArmorsEnabled() ? "layer_greenskins/orc_warlord_base_armor" : "greenskins/orc_warlord_armor";
			this.m.Items.equip(this.new("scripts/items/armor/" + armor));

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				local item = this.Const.World.Common.pickHelmet([
					[
						1,
						"greenskins/orc_warlord_helmet"
					]
				]);

				if (item != null)
				{
					this.m.Items.equip(item);
				}
			}
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/orc_warrior", function (obj) {
		obj.assignRandomEquipment = function()
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local weapons = [
					"weapons/greenskins/orc_axe",
					"weapons/greenskins/legend_skin_flayer",
					"weapons/greenskins/orc_cleaver"
				];
				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
			{
				this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_heavy_shield"));
			}

			local armors = [
				"orc_warrior_light",
				"orc_warrior_medium",
				"orc_warrior_heavy",
				"orc_warrior_heavy",
			];
			local armor = this.LegendsMod.Configs().LegendArmorsEnabled() ? "layer_greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_base_armor" : "greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_armor";
			this.m.Items.equip(this.new("scripts/items/armor/" + armor));

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				local helmet = [
					[
						1,
						"greenskins/orc_warrior_light_helmet"
					],
					[
						1,
						"greenskins/orc_warrior_medium_helmet"
					],
					[
						1,
						"greenskins/orc_warrior_heavy_helmet"
					]
				];
				local item = this.Const.World.Common.pickHelmet(helmet);
				this.m.Items.equip(item);
			}
		}
	});
	::mods_hookExactClass("entity/tactical/enemies/orc_warrior_low", function (obj) {
		obj.assignRandomEquipment = function()
		{
			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
			{
				local weapons = [
					"weapons/greenskins/orc_axe",
					"weapons/greenskins/legend_skin_flayer",
					"weapons/greenskins/orc_cleaver"
				];
				this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
			}

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
			{
				this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_heavy_shield"));
			}

			local armors = [
				"orc_warrior_light",
				"orc_warrior_medium",
			];
			local armor = this.LegendsMod.Configs().LegendArmorsEnabled() ? "layer_greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_base_armor" : "greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_armor";
			this.m.Items.equip(this.new("scripts/items/armor/" + armor));

			if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Head) == null)
			{
				local helmet = [
					[
						1,
						"greenskins/orc_warrior_light_helmet"
					],
					[
						1,
						"greenskins/orc_warrior_medium_helmet"
					],
				];
				local item = this.Const.World.Common.pickHelmet(helmet);
				this.m.Items.equip(item);
			}
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/orc_young", function (obj) {
		obj.assignRandomEquipment = function()
		{
			local r;
			local weapon;

			if (this.Math.rand(1, 100) <= 25)
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/orc_javelin"));
			}

			if (this.Math.rand(1, 100) <= 75)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					local r = this.Math.rand(1, 2);

					if (r == 1)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_axe");
					}
					else if (r == 2)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_cleaver");
					}
					else if (r == 3)
					{
						weapon = this.new("scripts/items/weapons/greenskins/legend_skin_flayer");
					}
				}
				else
				{
					local r = this.Math.rand(1, 3);

					if (r == 1)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_wooden_club");
					}
					else if (r == 2)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_metal_club");
					}
					else if (r == 3)
					{
						weapon = this.new("scripts/items/weapons/legend_chain");
					}
				}
			}
			else
			{
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					weapon = this.new("scripts/items/weapons/greenskins/goblin_falchion");
				}
				else if (r == 2)
				{
					weapon = this.new("scripts/items/weapons/morning_star");
				}
				else if (r == 3)
				{
					weapon = this.new("scripts/items/weapons/greenskins/legend_meat_hacker");
				}
				else if (r == 4)
				{
					weapon = this.new("scripts/items/weapons/greenskins/legend_bone_carver");
				}
			}

			if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
			{
				this.m.Items.equip(weapon);
			}
			else
			{
				this.m.Items.addToBag(weapon);
			}

			if (this.Math.rand(1, 100) <= 50)
			{
				this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_light_shield"));
			}

			if (this.Math.rand(1, 5) <= 4)
			{
				local armors = [
					"orc_young_very_light",
					"orc_young_light",
					"orc_young_medium",
					"orc_young_heavy",
				];
				local armor = this.LegendsMod.Configs().LegendArmorsEnabled() ? "layer_greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_base_armor" : "greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_armor";
				this.m.Items.equip(this.new("scripts/items/armor/" + armor));
			}

			local item = this.Const.World.Common.pickHelmet([
				[
					1,
					""
				],
				[
					1,
					"greenskins/orc_young_light_helmet"
				],
				[
					1,
					"greenskins/orc_young_medium_helmet"
				],
				[
					1,
					"greenskins/orc_young_heavy_helmet"
				]
			]);

			if (item != null)
			{
				this.m.Items.equip(item);
			}
		}
	});
	::mods_hookExactClass("entity/tactical/enemies/orc_young_low", function (obj) {
		obj.assignRandomEquipment = function()
		{
			local r;
			local weapon;

			if (this.Math.rand(1, 100) <= 25)
			{
				this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/orc_javelin"));
			}

			if (this.Math.rand(1, 100) <= 75)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					local r = this.Math.rand(1, 2);

					if (r == 1)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_axe");
					}
					else if (r == 2)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_cleaver");
					}
					else if (r == 3)
					{
						weapon = this.new("scripts/items/weapons/greenskins/legend_skin_flayer");
					}
				}
				else
				{
					local r = this.Math.rand(1, 3);

					if (r == 1)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_wooden_club");
					}
					else if (r == 2)
					{
						weapon = this.new("scripts/items/weapons/greenskins/orc_metal_club");
					}
					else if (r == 3)
					{
						weapon = this.new("scripts/items/weapons/legend_chain");
					}
				}
			}
			else
			{
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					weapon = this.new("scripts/items/weapons/greenskins/goblin_falchion");
				}
				else if (r == 2)
				{
					weapon = this.new("scripts/items/weapons/morning_star");
				}
				else if (r == 3)
				{
					weapon = this.new("scripts/items/weapons/greenskins/legend_meat_hacker");
				}
				else if (r == 4)
				{
					weapon = this.new("scripts/items/weapons/greenskins/legend_bone_carver");
				}
			}

			if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
			{
				this.m.Items.equip(weapon);
			}
			else
			{
				this.m.Items.addToBag(weapon);
			}

			if (this.Math.rand(1, 100) <= 50)
			{
				this.m.Items.equip(this.new("scripts/items/shields/greenskins/orc_light_shield"));
			}

			if (this.Math.rand(1, 5) <= 4)
			{
				local armors = [
					"orc_young_very_light",
					"orc_young_light",
					"orc_young_medium",
				];
				local armor = this.LegendsMod.Configs().LegendArmorsEnabled() ? "layer_greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_base_armor" : "greenskins/" + armors[this.Math.rand(0, armors.len() -1)] + "_armor";
				this.m.Items.equip(this.new("scripts/items/armor/" + armor));
			}

			local item = this.Const.World.Common.pickHelmet([
				[
					1,
					""
				],
				[
					2,
					"greenskins/orc_young_light_helmet"
				],
				[
					1,
					"greenskins/orc_young_medium_helmet"
				],
			]);

			if (item != null)
			{
				this.m.Items.equip(item);
			}
		}
	});

	//change equipment for armored unhold
	::mods_hookExactClass("entity/tactical/enemies/unhold_armored", function (obj) {
		obj.assignRandomEquipment = function()
		{
			if (!this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				this.m.Items.equip(this.new("scripts/items/armor/barbarians/unhold_armor_light"));
				this.m.Items.equip(this.new("scripts/items/helmets/barbarians/unhold_helmet_light"));
			}
			else 
			{
			    this.m.Items.equip(this.new("scripts/items/armor/layer_barbarians/unhold_armor_base_light"));
				this.m.Items.equip(this.new("scripts/items/helmets/layer_barbarians/unhold_helmet_base_light"));
			}
		}
	});

	::mods_hookExactClass("entity/tactical/enemies/unhold_frost_armored", function (obj) {
		obj.assignRandomEquipment = function()
		{
			if (!this.LegendsMod.Configs().LegendArmorsEnabled())
			{
				this.m.Items.equip(this.new("scripts/items/armor/barbarians/unhold_armor_heavy"));
				this.m.Items.equip(this.new("scripts/items/helmets/barbarians/unhold_helmet_heavy"));
			}
			else 
			{
			    this.m.Items.equip(this.new("scripts/items/armor/layer_barbarians/unhold_armor_base_heavy"));
				this.m.Items.equip(this.new("scripts/items/helmets/layer_barbarians/unhold_helmet_base_heavy"));
			}
		}
	});

	delete this.HexenHooks.hookActorAndEntity;
}