::mods_hookExactClass("skills/actives/uproot_skill", function ( obj )
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Send out roots to hold and damage enemies in a straight line.";
		this.m.KilledString = "Crushed";
		this.m.Icon = "skills/active_122.png";
		this.m.IconDisabled = "skills/active_122_sw.png";
		this.m.Overlay = "active_122";
	};
	obj.getTooltip = function()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can target the ground and hits up to 3 tiles in a line"
		});
		return ret;
	};
	obj.onAfterUpdate <- function( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? ::Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (_properties.IsSpecializedInSpears)
		{
			_properties.DamageRegularMin += 5;
			_properties.DamageRegularMax += 15;
			_properties.DamageArmorMult += 0.1;
		}
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		local ownTile = this.getContainer().getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		
		::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		
		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);
				
			if (forwardTile.IsOccupiedByActor || forwardTile.IsEmpty)
			{
				::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, forwardTile, forwardTile.Pos.X, forwardTile.Pos.Y);
			}
			
			if (forwardTile.hasNextTile(dir))
			{
				local followupTile = forwardTile.getNextTile(dir);
				
				if (followupTile.IsOccupiedByActor || followupTile.IsEmpty)
				{
					::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, followupTile, followupTile.Pos.X, followupTile.Pos.Y);
				}
			}
		}
	};
});