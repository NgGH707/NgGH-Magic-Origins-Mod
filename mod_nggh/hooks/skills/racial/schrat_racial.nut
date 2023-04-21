::mods_hookExactClass("skills/racial/schrat_racial", function(obj) 
{
	//obj.m.DamRec <- 0.3;
	obj.m.IsPlayer <- false;
	obj.m.Script <- "enemies/schrat_small";

	obj.getDamageRec <- function()
	{
		return !this.m.IsPlayer || ::Nggh_MagicConcept.IsOPMode ? 0.3 : 0.8;
	}

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Living Wood";
		this.m.Description = "As guardians of the forest, a Schrat has an incredibly resilient wooden body. Any part of its broken body part could grow into a living schrat too.";
		this.m.Icon = "skills/status_effect_86.png";
		this.m.IconMini = "status_effect_86_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		//this.m.DamRec = ::Nggh_MagicConcept.IsOPMode ? 0.3 : 0.8;
	};
	obj.onAdded <- function()
	{
		this.m.IsPlayer = this.getContainer().getActor().isPlayerControlled();

		if (!this.m.IsPlayer) return;
		
		this.m.Script = "minions/nggh_mod_schrat_small_minion";
	};
	obj.getTooltip <- function()
	{
		local actor = this.getContainer().getActor();
		local isSpecialized = this.getContainer().hasSkill("perk.sapling");
		local hp = ::Math.floor(actor.getHitpointsMax() * 0.1);
		local chance = 25 + (isSpecialized ? 10 : 0);
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/sturdiness.png",
				text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]" + ((1 - this.getDamageRec()) * 100) + "%[/color] less damage if has a shield equipped"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has [color=" + ::Const.UI.Color.PositiveValue + "]" + chance + "%[/color] to spawn a Sapling when taking at least [color=" + ::Const.UI.Color.PositiveValue + "]" + hp + "[/color] damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Resistant[/color] against Ranged or Piercing Damage"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Vulnerable[/color] against Fire Damage"
			}
		];

		return ret;
	};
	local ws_isHidden = obj.isHidden;
	obj.isHidden = function()
	{
		if (!::Tactical.isActive())
		{
			return false;
		}

		return ws_isHidden();
	};
	obj.onUpdate = function( _properties )
	{
		if (this.getContainer().getActor().isArmedWithShield())
		{
			_properties.DamageReceivedTotalMult *= this.getDamageRec();
		}
	};
	obj.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();
		local isPlayer = actor.isPlayerControlled();
		local isSpecialized = this.getContainer().hasSkill("perk.sapling");

		if (_damageHitpoints >= actor.getHitpointsMax() * 0.1)
		{
			local candidates = [];
			local myTile = actor.getTile();

			for( local i = 0; i < 6; ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = myTile.getNextTile(i);

					if (nextTile.IsEmpty && ::Math.abs(myTile.Level - nextTile.Level) <= 1)
					{
						candidates.push(nextTile);
					}
				}
			}

			local bonus = isSpecialized ? 10 : 0;

			if (candidates.len() != 0)
			{
				if (isPlayer && ::Math.rand(1, 100) > 25 + bonus) return;

				local sapling = ::Tactical.spawnEntity("scripts/entity/tactical/" + this.m.Script, ::MSU.Array.rand(candidates).Coords);
				sapling.setFaction(isPlayer ? ::Const.Faction.PlayerAnimals : actor.getFaction());

				if (isPlayer && isSpecialized)
				{
					sapling.setMaster(actor);
					sapling.makeControllable();
				}

				sapling.riseFromGround();
			}
		}
	};
});