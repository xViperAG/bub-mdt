import React, { useRef, useState } from "react";
import { Button, Stack, TextInput } from "@mantine/core";
import { modals } from "@mantine/modals";
import { fetchNui } from "../../../../../utils/fetchNui";
import locales from "../../../../../locales";
import useWeaponsStore from "../../../../../stores/weapons/weapons";

interface Props {
	image?: string;
}

const AvatarModal: React.FC<Props> = (props) => {
	const { setSelectedWeapon, selectedWeapon } = useWeaponsStore();
	const inputRef = useRef<HTMLInputElement | null>(null);
	const [isLoading, setIsLoading] = useState(false);

	const handleConfirm = async () => {
		if (!selectedWeapon) return;
		setIsLoading(true);
		const image = inputRef.current?.value;
		await fetchNui(
			"updateWeaponImage",
			{ serial: selectedWeapon.serial, image: image },
			{ data: 1 }
		);
		setSelectedWeapon({ ...selectedWeapon, image });
		modals.closeAll();
	};

	return (
		<Stack>
			<TextInput
				defaultValue={props.image}
				ref={inputRef}
				label={locales.image}
				description={locales.avatar_description_weapon}
				placeholder='https://r2.fivemanage.com/placeholder.jpg'
			/>
			<Button
				variant='light'
				color='gray'
				onClick={handleConfirm}
				loading={isLoading}
			>
				{locales.confirm}
			</Button>
		</Stack>
	);
};

export default AvatarModal;
