::mods_hookExactClass("skills/actives/ghoul_claws", function ( obj )
{
	obj.getTooltip = function()
	{
		return this.getDefaultTooltip();
	};
	obj.onBeforeUse <- function( _user , _targetTile )
	{
		if (!_user.getFlags().has("luft"))
		{
			return;
		}
		
		::Tactical.spawnSpriteEffect("luft_claw_quote_" + ::Math.rand(1, 5), ::createColor("#ffffff"), _user.getTile(), ::Const.Tactical.Settings.SkillOverlayOffsetX, 145, ::Const.Tactical.Settings.SkillOverlayScale, ::Const.Tactical.Settings.SkillOverlayScale, ::Const.Tactical.Settings.SkillOverlayStayDuration + 300, 0, ::Const.Tactical.Settings.SkillOverlayFadeDuration);
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInShields ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
});