import { create } from "zustand";
import { PartialWeaponData, Weapon } from "../../typings";
import { isEnvBrowser } from "../../utils/misc";
import { fetchNui } from "../../utils/fetchNui";

const DEBUG_WEAPONS: PartialWeaponData[] = [];

for (let i = 0; i < 25; i++) {
    DEBUG_WEAPONS[i] = {
        model: "M4",
        serial: `237581PTA284859${i + 1}`,
    };
}

export const DEBUG_WEAPON1: Weapon = {
    model: "M4",
    class: 'Class: 3',
    serial: '237581PTA284859',
	notes: "string",
    owner: "John Doe (ABC123AW)",
	knownInformation: ["AK-74"],
};

export const DEBUG_WEAPON2: Weapon = {
    model: "AK-74",
    class: 'Class: 3',
    serial: '237581PTA284859',
	notes: "string",
    owner: "John Doe (ABC123AW)",
	knownInformation: ["AK-74"],
};

type WeaponsStore = {
    selectedWeapon: Weapon | null;
    getWeapons: () => Promise<PartialWeaponData[]>;
    setSelectedWeapon: (weapon: Weapon | null) => void;
};

const useWeaponsStore = create<WeaponsStore>((set) => ({
    selectedWeapon: null,
    getWeapons: async (): Promise<PartialWeaponData[]> => {
        if (isEnvBrowser()) {
            return DEBUG_WEAPONS;
        }

        return await fetchNui<PartialWeaponData[]>("getAllWeapons");
    },
    setSelectedWeapon: (weapon: Weapon | null) => {
        if (isEnvBrowser())
            set({
                selectedWeapon:
                    Math.random() * 10 > 5 ? DEBUG_WEAPON1 : DEBUG_WEAPON2
            });

        set({ selectedWeapon: weapon });
    },
}));

export default useWeaponsStore;