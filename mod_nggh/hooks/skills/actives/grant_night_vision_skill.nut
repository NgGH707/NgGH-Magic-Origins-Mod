::mods_hookExactClass("skills/actives/grant_night_vision_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		//this.m.IsMagicSkill = true;
		//this.m.MagicPointsCost = 1;
		//this.m.IsRequireStaff = true;
		this.m.Description = "A simple chant to give a group of your men the ability to see through the darkness of the night.";
		this.m.Icon = "skills/active_156.png";
		this.m.IconDisabled = "skills/active_156_sw.png";
		this.m.Order = ::Const.SkillOrder.UtilityTargeted + 3;
		this.m.IsTargetingActor = false;
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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes [color=" + ::Const.UI.Color.NegativeValue + "]Nighttime[/color] penalties to a group of allies"
			}
		];
		
		if (this.m.IsSpent)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + ::Const.UI.Color.NegativeValue + "]Can only be used once per turn[/color]"
			});
		}

		return ret;
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		for( local i = 0; i < 6; ++i )
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
	}
});