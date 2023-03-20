::mods_hookExactClass("skills/racial/alp_racial", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Partly Exist In Dreams";
		this.m.Description = "Has strong resistance against ranged or piercing attacks due to part of its real body only existing in a dream. It has the habbit to haunt and stalk its prey.";
		this.m.Icon = "skills/status_effect_102.png";
		this.m.IconMini = "status_effect_102_mini";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.getTooltip <- function()
	{
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
			}
		]

		if (!::Nggh_MagicConcept.IsOPMode)
		{
			ret.extend([
				{
					id = 6,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15%[/color] Melee Damage"
				},
				{
					id = 7,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + ::Const.UI.Color.NegativeValue + "]-15%[/color] Ranged Damage"
				}
			]);
		}

		ret.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.PositiveValue + "]Resistant[/color] against Piercing or Ranged Damage"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Vulnerable[/color] against Fire Damage"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Causes allied Alps to teleport after taking damage"
			}
		]);

		return ret;
	};
	obj.onAdded <- function()
	{
		if (!this.getContainer().getActor().isPlayerControlled()) return;
		
		this.getContainer().getActor().getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_alp_teleport"));
	};

	// nerf alp player
	obj.onUpdate <- function( _properties )
	{
		if (::Nggh_MagicConcept.IsOPMode) return;

		_properties.MeleeDamageMult *= ::Const.AlpWeaponDamageMod;
		_properties.RangedDamageMult *= ::Const.AlpWeaponDamageMod;
	}

	obj.onDamageReceived = function( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();

		if (_damageHitpoints >= actor.getHitpoints())
		{
			return;
		}
		
		::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Skill);
		::Time.scheduleEvent(::TimeUnit.Virtual, 30, this.teleport.bindenv(this), {
			Faction = this.getContainer().getActor().getFaction(),
		});
	};
	obj.onDeath = function( _fatalityType )
	{
		::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.Skill);
		::Time.scheduleEvent(::TimeUnit.Virtual, 30, this.teleport.bindenv(this), {
			Faction = this.getContainer().getActor().getFaction(),
		});
	};
	obj.teleport = function( _tag )
	{
		foreach( a in ::Tactical.Entities.getInstancesOfFaction(_tag.Faction) )
		{
			local skill = a.getSkills().getSkillByID("actives.alp_teleport");

			if (skill != null && a.isAlive() && a.getHitpoints() > 0)
			{
				if (!a.getFlags().get("auto_teleport"))
				{
					continue;
				}

				if (!a.getAIAgent().hasKnownOpponent())
				{
					local strategy = a.getAIAgent().getStrategy().update();
					do
					{
					}
					while (!resume strategy);
				}
				
				local b = a.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AlpTeleport);
				b.onEvaluate(a);
				b.onExecute(a);
			}
		}
	};
});