pragma solidity ^0.8.0;

/**
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

/**
 * @author Heisenberg
 * @title Buffer BNB Bidirectional (Call and Put) Options
 * @notice Buffer BNB Options Contract
 */

import "../../Interfaces/Interfaces.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract OptionWindowCreator is IOptionWindowCreator, Ownable {
    OptionCreationWindow public optionCreationWindow =
        OptionCreationWindow(0, 0, 0, 0);

    /**
     * @notice Used for changing option creation window
     * @param startHour Starting hour of each day
     * @param startMinute Starting minute of each day
     * @param endHour Ending hour of each day
     * @param endMinute Ending minute of each day
     */
    function setOptionCreationWindow(
        uint256 startHour,
        uint256 startMinute,
        uint256 endHour,
        uint256 endMinute
    ) external onlyOwner {
        optionCreationWindow = OptionCreationWindow(
            startHour,
            startMinute,
            endHour,
            endMinute
        );
        emit UpdateOptionCreationWindow(
            startHour,
            startMinute,
            endHour,
            endMinute
        );
    }

    /**
     * @notice Check if the options can be created
     */
    function IsInOptionCreationWindow() public view returns (bool) {
        uint256 currentHour = (block.timestamp / 3600) % 24;
        uint256 currentMinute = (block.timestamp % 3600) / 60;

        // Allow default value of optionCreationWindow
        if (
            optionCreationWindow.startHour == 0 &&
            optionCreationWindow.startMinute == 0 &&
            optionCreationWindow.endHour == 0 &&
            optionCreationWindow.endMinute == 0
        ) {
            return true;
        }

        if (
            ((currentHour == optionCreationWindow.startHour &&
                currentMinute >= optionCreationWindow.startMinute) ||
                currentHour > optionCreationWindow.startHour) &&
            (currentHour < optionCreationWindow.endHour ||
                (currentHour == optionCreationWindow.endHour &&
                    currentMinute <= optionCreationWindow.endMinute))
        ) {
            return true;
        }
        return false;
    }
}
