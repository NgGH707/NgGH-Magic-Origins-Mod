::mods_hookExactClass("skills/actives/root_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Unleash roots from the ground to ensnare your foes. Fatigue and AP costs reduced while raining and with staff mastery. ";
		this.m.Icon = "skills/active_70.png";
		this.m.IconDisabled = "skills/active_70_sw.png";
	};
	obj.onAdded <- function()
	{
		this.m.FatigueCost = this.getContainer().getActor().isPlayerControlled() ? 20 : this.m.FatigueCost;
	};
	obj.getTooltip <- function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can hit up to 7 targets"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Trapped targets in Vines"
			}
		]);
		return ret;
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);	
			}
		}
	};
});