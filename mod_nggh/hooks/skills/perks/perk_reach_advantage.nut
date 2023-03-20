::mods_hookExactClass("skills/perks/perk_reach_advantage", function(obj) 
{
	local ws_onTargetHit = obj.onTargetHit;
	obj.onTargetHit = function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.getContainer().getActor().getFlags().has("lindwurm") && _skill != null && _skill.getID() != "actives.spit_acid")
		{
			this.m.Stacks = ::Math.min(this.m.Stacks + 1, 5);
			return;
		}

		ws_onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
	};

	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		this.m.IsHidden = this.m.Stacks == 0;

		if (this.getContainer().getActor().getFlags().has("lindwurm")) 
		{
			_properties.MeleeDefense += this.m.Stacks * 5;
			return;
		}

		ws_onUpdate(_properties);
	}
});