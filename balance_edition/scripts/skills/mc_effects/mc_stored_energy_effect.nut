this.mc_stored_energy_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Energy = 0,
		EnergyMax = 150,
		MaximunPerUse = 15,
		IsActivated = false,
	},
	function activate()
	{
		this.m.IsActivated = true;
	}

	function addEnergy( _v )
	{
		local added = this.Math.min(_v, this.m.EnergyMax - this.m.Energy);
		this.m.Energy = this.Math.min(this.m.EnergyMax, this.m.Energy + added);
		return added;
	}

	function useEnergy()
	{
		local energyUsed = this.expectedEnergyUsage();
		this.m.Energy = this.Math.max(0, this.m.Energy - energyUsed.Energy);

		if (this.m.Energy == 0)
		{
			this.removeSelf();
		}

		return energyUsed;
	}

	function expectedEnergyUsage()
	{
		local usage = this.Math.min(this.m.MaximunPerUse, this.m.Energy);
		return {
			Energy = usage,
			DamMax = usage,
			DamMin = this.Math.floor(usage * 0.75)
		};
	}
	
	function create()
	{
		this.m.ID = "effects.mc_stored_energy";
		this.m.Name = "Absorbed Energy";
		this.m.Icon = "skills/effect_mc_01.png";
		this.m.IconMini = "effect_mc_01_mini";
		this.m.Overlay = "effect_mc_01";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}
	
	function getDescription()
	{
		return "Energy you stole from the enemy are contained in here. It will be used to improve your magical attack or adding some armor ignore damage to your staff bash."
	}
	
	function getTooltip()
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
			},
		];

		ret.extend(this.getEnergyTooltips(false));
		return ret;
	}

	function getEnergyTooltips( _getExpectedDamage = true )
	{
		local ret = [];
		ret.push({
			id = 5,
			type = "progressbar",
			icon = "ui/icons/asset_business_reputation.png",
			value = this.m.Energy,
			valueMax = this.m.EnergyMax,
			text = "" + this.m.Energy + " / " + this.m.EnergyMax + "",
			style = "fatigue-slim"
		});

		if (_getExpectedDamage)
		{
			ret.insert(0, {
				id = 3,
				type = "text",
				text = "[u][size=14]Absorbed Energy[/size][/u]"
			});

			local data = this.expectedEnergyUsage();

			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Will spend [color=" + this.Const.UI.Color.PositiveValue + "]" + data.Energy + "[/color] energy to increase this skill damage by [color=" + this.Const.UI.Color.DamageValue + "]" + data.DamMin + "[/color]-[color=" + this.Const.UI.Color.DamageValue + "]" + data.DamMax + "[/color]"
			});
		}

		return ret;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (this.m.IsActivated)
		{
			local data = this.useEnergy();
			local damage = this.Math.rand(data.DamMin, data.DamMax);

			if (_hitInfo.DamageRegular > 0)
			{
				_hitInfo.DamageRegular += damage
			}

			if (_hitInfo.DamageArmor > 0)
			{
				_hitInfo.DamageArmor += damage
			}

			this.m.IsActivated = false;
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (this.m.IsActivated)
		{
			this.useEnergy();
			this.m.IsActivated = false;
		}
	}
	
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity == null || !_targetEntity.isAlive() || _targetEntity.isDying())
		{
			return;
		}

		local staff_attacks = [
			"actives.legend_staff_thrust",
			"actives.legend_staff_lunge",
			"actives.legend_staff_knock_out",
			"actives.legend_staff_bash",
		];

		if (_skill == null || staff_attacks.find(_skill.getID()) == null)
		{
			return;
		}

		this.spawnIcon(this.m.Overlay, _targetEntity.getTile());
		local hitInfo = clone this.Const.Tactical.HitInfo;
		local data = this.useEnergy();
		hitInfo.DamageRegular = this.Math.rand(this.Math.floor(data.DamMax * 0.5), data.DamMax);
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_targetEntity.onDamageReceived(this.getContainer().getActor(), this, hitInfo);
	}

	function onTurnStart()
	{
		this.m.Energy -= 5;

		if (this.m.Energy <= 0)
		{
			this.removeSelf();
		}
	}

});

