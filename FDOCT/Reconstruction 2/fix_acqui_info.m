function acqui_info=fix_acqui_info(acqui_info)

acqui_info.x_FOV_um=abs(acqui_info.x_FOV_um);
acqui_info.y_FOV_um=abs(acqui_info.y_FOV_um);