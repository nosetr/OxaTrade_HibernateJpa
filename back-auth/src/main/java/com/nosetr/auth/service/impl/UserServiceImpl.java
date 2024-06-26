package com.nosetr.auth.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.nosetr.auth.dto.UserDto;
import com.nosetr.auth.dto.UserRegisterDto;
import com.nosetr.auth.dto.UserUpdateDto;
import com.nosetr.auth.entity.RoleEntity;
import com.nosetr.auth.entity.UserEntity;
import com.nosetr.auth.mapper.UserMapper;
import com.nosetr.auth.repository.UserRepository;
import com.nosetr.auth.service.RoleService;
import com.nosetr.auth.service.UserService;
import com.nosetr.auth.util.PBFDK2Encoder;
import com.nosetr.library.enums.ErrorEnum;
import com.nosetr.library.exception.EntityAlreadyExistsException;
import com.nosetr.library.exception.EntityNotFoundException;
import com.nosetr.library.exception.UnauthorizedException;

import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

/**
 * Implementation of UserService for users actions.
 * 
 * @autor Nikolay Osetrov
 * @since 0.1.0
 * @see   PBFDK2Encoder
 */
@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(makeFinal = true, level = AccessLevel.PRIVATE)
public class UserServiceImpl implements UserService {

	UserRepository userRepository;
	PBFDK2Encoder passwordEncoder;
	UserMapper userMapper;
	RoleService roleService;

	/**
	 * Create new user with UserRepository.
	 * 
	 * @autor             Nikolay Osetrov
	 * @since             0.1.0
	 * @param  userEntity UserEntity
	 * @return
	 * @see               PBFDK2Encoder
	 */
	@Override
	@Transactional()
	public UserDto registerUser(UserRegisterDto userDto) {
		UserEntity userEntity = userMapper.map(userDto);
		String email = userEntity.getEmail();

		// Check if email is already in use:
		Optional<UserEntity> optionalUser = userRepository.findByEmail(email);
		if (optionalUser.isPresent()) {
			throw new EntityAlreadyExistsException(ErrorEnum.USER_WITH_EMAIL_ALREADY_EXISTS, email);
		}
		
		Set<RoleEntity> defaultRoles = roleService.getDefaultRoles();
		
		// Create new user:
		userEntity.setPassword(passwordEncoder.encode(userEntity.getPassword()));
		userEntity.setUserRoles(defaultRoles);
		userEntity.setEnabled(true); // TODO: Set this to false when email verification system is implemented.

		UserEntity savedUser = userRepository.save(userEntity);

		// Log user creation
		log.info("IN registerUser - user: {} created", savedUser);

		return userMapper.map(savedUser);
	}

	/**
	 * Update user by ID
	 * 
	 * @autor          Nikolay Osetrov
	 * @since          0.1.0
	 * @param  id
	 * @param  userDto
	 * @return
	 */
	@Override
	@Transactional
	public UserDto update(UUID id, UserUpdateDto userDto) {

		UserEntity userEntity = userRepository.findById(id)
				.orElseThrow(() -> new EntityNotFoundException(ErrorEnum.USER_NOT_FOUND));

		// Check if user is active
		if (!userEntity.isEnabled()) { throw new UnauthorizedException(ErrorEnum.USER_ACCOUNT_IS_DISABLED); }

		// Update the user object with data from userDto
		UserEntity updatedUser = userMapper.updateUserFromDto(
				userDto, userEntity.toBuilder()
						.updatedAt(LocalDateTime.now())
						.build()
		);

		// Save the updated user object
		UserEntity savedUser = userRepository.save(updatedUser);

		// Convert the saved user object to a DTO and return it
		return userMapper.map(savedUser);
	}

	/**
	 * Find user by ID
	 * 
	 * @autor     Nikolay Osetrov
	 * @since     0.1.0
	 * @param  id UUID
	 * @return
	 */
	@Override
	public UserDto getUserById(UUID id) throws EntityNotFoundException {
		return userMapper.map(
				userRepository.findById(id)
						.orElseThrow(() -> new EntityNotFoundException(ErrorEnum.USER_NOT_FOUND))
		);
	}

	/**
	 * Find user by email
	 * 
	 * @autor        Nikolay Osetrov
	 * @since        0.1.0
	 * @param  email String
	 * @return
	 */
	@Override
	public UserDto getUserByEmail(String email) throws EntityNotFoundException {
		return userMapper.map(
				userRepository.findByEmail(email)
						.orElseThrow(() -> new EntityNotFoundException(ErrorEnum.USER_NOT_FOUND))
		);
	}

	/**
	 * ++++++++++++++++++++++++++++++++++++++++++++++++++++
	 * Get all users
	 * 
	 * @autor  Nikolay Osetrov
	 * @since  0.1.0
	 * @return
	 */
	@Override
	public List<UserDto> getAll() { return userMapper.map(userRepository.findAll()); }

	/**
	 * Delete user by ID
	 * 
	 * @autor     Nikolay Osetrov
	 * @since     0.1.0
	 * @param  id UUID
	 * @return
	 */
	@Override
	@Transactional
	public void deleteById(UUID id) {
		userRepository.deleteById(id);
	}

	/**
	 * Delete all users
	 * 
	 * @autor  Nikolay Osetrov
	 * @since  0.1.0
	 * @return
	 */
	@Override
	@Transactional
	public void deleteAll() {
		userRepository.deleteAll();
	}

}
