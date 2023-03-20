::mods_hookExactClass("skills/actives/sweep_zoc_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.IsHidden = true;
	};
	obj.isUsable <- function()
	{
		return this.m.IsUsable && this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills;
	};
	obj.getMods <- function()
	{
		local ret = {
			Min = 0,
			Max = 0,
			HasTraining = false
		};
		local actor = this.getContainer().getActor();

		if (actor.getSkills().hasSkill("perk.legend_unarmed_training"))
		{
			local average = actor.getHitpoints() * 0.05;

			ret.Min += average;
			ret.Max += average;
			ret.HasTraining = true;
		}

		ret.Min = ::Math.max(0, ::Math.floor(ret.Min));
		ret.Max = ::Math.max(0, ::Math.floor(ret.Max));
		return ret;
	};
	obj.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (_skill != this) return;

		local mods = this.getMods();
		_properties.DamageRegularMin += mods.Min;
		_properties.DamageRegularMax += mods.Max;

		if (mods.HasTraining)
		{
			_properties.DamageArmorMult += 0.1;
		}
	};
});