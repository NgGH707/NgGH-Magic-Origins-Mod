/*
::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(obj) 
{
	obj.setActiveEntityMagicPointsCostsPreview <- function( _costsPreview )
	{
		local previewData = {};
		previewData.id <- activeEntity.getID();
		previewData.MagicPointsPreview <- activeEntity.getMagicPoints() - _costsPreview.MagicPoints;

		if (previewData.MagicPointsPreview < 0)
		{
			previewData.MagicPointsPreview = activeEntity.getMagicPoints();
		}

		previewData.MagicPointsMaxPreview <- activeEntity.getMagicPointsMax();
		activeEntity.setPreviewMagicPoints(previewData.MagicPointsPreview);
		this.m.JSHandle.asyncCall("updateCostsPreview", previewData);
	}

	obj.resetActiveEntityMagicPointsCostsPreview <- function()
	{
		local activeEntity = this.getActiveEntity();

		if (activeEntity != null)
		{
			this.m.JSHandle.asyncCall("updateCostsPreview", {
				MagicPointsPreview = activeEntity.getMagicPoints(),
				MagicPointsMaxPreview = activeEntity.getMagicPointsMax(),
			});
			activeEntity.setPreviewFatigue(activeEntity.getMagicPoints());
		}
	}
});
*/