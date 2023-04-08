::mods_hookExactClass("skills/actives/legend_skin_ghoul_claws", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted + 3;
		this.m.IsIgnoredAsAOO = true;
	};
	obj.isHidden <- function()
	{
		return this.getContainer().getActor().getMainhandItem() != null && !this.getContainer().hasSkill("effects.disarmed") || this.skill.isHidden();
	};
	obj.onAdded <- function()
	{
		this.getContainer().add(::new("scripts/skills/actives/nggh_mod_ghoul_claws_zoc"));
	};
	obj.getTooltip = function()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 3 targets"
			}
		]);
		return ret;
	};

	local ws_onUpdate = obj.onUpdate;
	obj.onUpdate = function( _properties )
	{
		if (!this.isHidden())
		{
			ws_onUpdate(_properties);
		}
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	};
	obj.onBeforeUse <- function( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Nggh_MagicConcept.spawnQuote("luft_claw_quote_" + ::Math.rand(1, 5), _user.getTile());
	};
});