::mods_hookExactClass("skills/racial/goblin_ambusher_racial", function(obj) 
{
	//obj.m.Chance <- 0;
	obj.m.IsPlayer <- false;

	obj.getChance <- function()
	{
		return !this.m.IsPlayer || ::Nggh_MagicConcept.IsOPMode ? 100 : 35;
	}

	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Name = "Poisonous Weapon";
		this.m.Description = "Goblins love using poison to weaken their prey and enemy. Instead of killing its victim this poison will instead slow them down, prevent them from getting away.";
		this.m.Icon = "skills/status_effect_00.png";
		this.m.IconMini = "status_effect_54_mini";
		//this.m.Chance = ::Nggh_MagicConcept.IsOPMode ? 100 : 35;
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.First + 1;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	};
	obj.onAdded <- function()
	{
		this.m.IsPlayer = this.getContainer().getActor().isPlayerControlled();
	}
	obj.getTooltip <- function()
	{
		return [
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
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getChance() + "%[/color] to inflicts [color=" + ::Const.UI.Color.DamageValue + "]Goblin Poisoned[/color] effect on each attack"
			}
		];
	};

	local ws_onTargetHit = obj.onTargetHit;
	obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == null || !_skill.m.IsWeaponSkill)
		{
			return;
		}

		if (!::Nggh_MagicConcept.IsOPMode && this.getContainer().getActor().isPlayerControlled() && ::Math.rand(1, 100) > this.getChance())
		{
			return;
		}

		ws_onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	};
});