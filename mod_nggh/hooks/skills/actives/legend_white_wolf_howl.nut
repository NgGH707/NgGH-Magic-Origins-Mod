::mods_hookExactClass("skills/actives/legend_white_wolf_howl", function(obj) 
{
	local ws_create = obj.create;
	obj.create = function()
	{
		ws_create();
		this.m.Description = "A fearsome howl that boosts the fighting spirit of its herd members.";
		this.m.Icon = "skills/active_22.png";
		this.m.IconDisabled = "skills/active_22_sw.png";
	};
	obj.getTooltip = function()
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
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has an effective range of [color=" + ::Const.UI.Color.PositiveValue + "]6[/color] tiles raidus"
			}
		];
	};
	obj.raiseMorale = function( _actor )
	{
		_actor.checkMorale(1, 0);
		this.spawnIcon("status_effect_06", _actor.getTile());
	};
	obj.onUse = function( _user, _targetTile )
	{
		foreach( a in ::Tactical.Entities.getAlliedActors(_user.getFaction(), _user.getTile(), 6) )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}
			
			a.getSkills().removeByID("effects.sleeping");
			this.raiseMorale(a);
		}
		return true;
	};
});