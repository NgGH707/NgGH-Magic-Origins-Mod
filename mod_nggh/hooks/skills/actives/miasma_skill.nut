::mods_hookExactClass("skills/actives/miasma_skill", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "Release a cloud of noxious gasses that effects living beings";
		this.m.Icon = "skills/active_101.png";
		this.m.IconDisabled = "skills/active_101_sw.png";
		this.m.Order =  ::Const.SkillOrder.UtilityTargeted + 3;
		this.m.FatigueCost = 20;
	};
	obj.onAdded <- function()
	{
		// huge nerf for player
		if (this.getContainer().getActor().isPlayerControlled())
		{
			this.m.ActionPointCost = 8;
			this.m.FatigueCost = 30;
		}
	};
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" +  ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "Deals 5-10 damage per turn over four turns"
			}
		];
	};
	obj.onTargetSelected <- function( _targetTile )
	{
		local ownTile = _targetTile;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);

				if ( ::Math.abs(tile.Level - ownTile.Level) <= 1)
				{
					 ::Tactical.getHighlighter().addOverlayIcon( ::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
				}
			}
		}
	};
});