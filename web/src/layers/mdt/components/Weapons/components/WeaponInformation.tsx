import {
	ActionIcon,
	Button,
	Divider,
	Image,
	Indicator,
	Input,
	MultiSelect,
	Text,
	Tooltip,
	rem,
} from "@mantine/core";
import {
	IconBadgeTm,
	IconSword,
	IconEdit,
	IconId,
	IconInfoCircle,
	IconLinkOff,
	IconUserOff,
} from "@tabler/icons-react";
import TextEditor from "../../TextEditor";
import "../index.css";
import locales from "../../../../../locales";
import useWeaponsStore from "../../../../../stores/weapons/weapons";
import WeaponModal from "../modals/WeaponModal";
import { fetchNui } from "../../../../../utils/fetchNui";
import { useState } from "react";
import { modals } from "@mantine/modals";
import { capitalizeFirstLetter } from "../../../../../helpers";

const WeaponInformation = () => {
	const {
		selectedWeapon,
		setSelectedWeapon,
	} = useWeaponsStore();
	const [hovering, setHovering] = useState(false);

	if (!selectedWeapon)
		return (
			<div className='weapon-content-width'>
				<div className='card-background'>
					<div className='profile-no-selected'>
						<IconUserOff size={rem(50)} color='white' />
						<Text style={{ fontSize: 15, color: "white" }} weight={600}>
							{locales.no_weapon_selected}
						</Text>
					</div>
				</div>
			</div>
		);

	return (
		<div className='weapon-content-width'>
			<div className='card-background'>
				<div className='weapon-card-content'>
					<div className='weapon-card-header'>
						<Text style={{ fontSize: 17, color: "white" }} weight={500}>
							{locales.weapon_information}
						</Text>

						<div className='weapon-card-header-buttons'>
							<Tooltip
								label={locales.unlink}
								withArrow
								color='gray'
								position='bottom'
							>
								<ActionIcon
									variant='filled'
									color='gray'
									onClick={() => {
										setSelectedWeapon(null);
									}}
								>
									<IconLinkOff size={16} color={"white"} />
								</ActionIcon>
							</Tooltip>
						</div>
					</div>

					<div className='weapon-card-information'>
						<div
							className='weapon-card-image'
							onMouseEnter={() => setHovering(true)}
							onMouseLeave={() => setHovering(false)}
						>
							{hovering && (
								<ActionIcon
									style={{ position: "absolute", top: 5, right: 5, zIndex: 99 }}
									onClick={() =>
										modals.open({
											title: (
												<Text
													style={{ fontSize: 17, color: "white" }}
													weight={500}
												>
													{locales.change_picture}
												</Text>
											),
											centered: true,
											size: "sm",
											children: <WeaponModal />,
										})
									}
								>
									<IconEdit />
								</ActionIcon>
							)}
                            <Indicator>
								<Image
									src={
										selectedWeapon.image
											? selectedWeapon.image
											: `https://cfx-nui-ox_inventory/web/images/${selectedWeapon.model.toLowerCase()}.png`
									}
									radius={"lg"}
									height={225}
									width={500}
									withPlaceholder
									placeholder={
										<Text align='center'>Image of weapon was not found</Text>
									}
								/>
							</Indicator>
						</div>

						<div className='weapon-card-information-inputs'>
							<Input
								disabled
								icon={<IconId size={16} />}
								placeholder={selectedWeapon.owner}
								size='sm'
							/>

							<Input
								disabled
								icon={<IconBadgeTm size={16} />}
								placeholder={selectedWeapon.serial}
								size='sm'
							/>

							<Input
								disabled
								icon={<IconInfoCircle size={16} />}
								placeholder={selectedWeapon.class}
								size='sm'
							/>

							<Input
								disabled
								icon={<IconSword size={16} />}
								placeholder={capitalizeFirstLetter(selectedWeapon.model)}
								size='sm'
							/>
						</div>
					</div>

					<div
						style={{
							display: "flex",
							flexDirection: "column",
							justifyContent: "center",
							alignItems: "center",
							gap: 10,
						}}
					>
					</div>

					<Divider w={"100%"} />

					<div className='weapon-card-extra-information'>
						<Text style={{ fontSize: 17, color: "white" }} weight={500}>
							{locales.known_information}
						</Text>

						<MultiSelect
							data={selectedWeapon.knownInformation}
							defaultValue={selectedWeapon.knownInformation}
							placeholder={locales.select_items}
							w={"100%"}
							searchable
							creatable
							styles={{ value: { backgroundColor: "#343a40" } }}
							getCreateLabel={(query) => `+ Create ${query}`}
							onCreate={(query) => {
								fetchNui(
									"saveWeaponInformation",
									{
										serial: selectedWeapon.serial,
										knownInformation: [
											...selectedWeapon.knownInformation,
											query,
										],
									},
									{ data: 1 }
								);
								const updatedWeapon = {
									...selectedWeapon,
									knownInformation: [
										...selectedWeapon.knownInformation,
										query,
									],
								};
								setSelectedWeapon(updatedWeapon);
								return query;
							}}
						/>
					</div>

					<Divider w={"100%"} />

					<div className='weapon-card-notes'>
						<TextEditor
							content={selectedWeapon.notes}
							onSave={(value) => {
								setSelectedWeapon({ ...selectedWeapon, notes: value });

								fetchNui("saveWeaponNotes", {
									serial: selectedWeapon.serial,
									notes: value,
								});
							}}
							styles={{
								content: { backgroundColor: "#242527" },
								toolbar: { backgroundColor: "#2C2E33" },
								controlsGroup: {
									pointerEvents: "auto",
									backgroundColor: "#282828",
								},
							}}
							contentAreaStyle={{ height: 270, width: "100%", padding: 0 }}
						/>
					</div>
				</div>
			</div>
		</div>
	);
};

export default WeaponInformation;
