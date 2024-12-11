import "./index.css";
import { LoadingOverlay } from "@mantine/core";
import CustomLoader from "../CustomLoader";
import { useState } from "react";
import { PartialWeaponData, Weapon } from "../../../../typings";
import { fetchNui } from "../../../../utils/fetchNui";
import useWeaponsStore, {
    DEBUG_WEAPON1,
    DEBUG_WEAPON2
} from "../../../../stores/weapons/weapons";
import WeaponList from "./components/WeaponList";
import WeaponInformation from "./components/WeaponInformation";

const Weapons = () => {
    const[loading, setLoading] = useState(false);
    const { setSelectedWeapon } = useWeaponsStore();
    const DEBUG_WEAP = Math.random() * 10 > 5 ? DEBUG_WEAPON1 : DEBUG_WEAPON2;

    const handleWeaponClick = async (weapon: PartialWeaponData) => {
        setLoading(true);
        setSelectedWeapon(null);
        const resp = await fetchNui<Weapon>(
            "getWeapon",
            { serial: weapon.serial },
            {
                data: {
                    ...DEBUG_WEAP,
                },
            }
        );

        setLoading(false);
        setSelectedWeapon(resp);
    }

    return (
        <div className='weapons'>
            <WeaponList handleWeaponClick={handleWeaponClick} />

            <LoadingOverlay
                visible={loading}
                overlayOpacity={0.97}
                overlayColor={"rgb(34, 35, 37)"}
                transitionDuration={250}
                loader={CustomLoader}
                style={{
                    left: 1029,
                    width: 700,
                    height: "95.75%",
                    top: 19,
                    borderRadius:"0.25rem",
                }}
            />
            <WeaponInformation />
        </div>
    );
};

export default Weapons;