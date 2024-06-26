package com.nosetr.auth.util;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import com.nosetr.auth.entity.UserEntity;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

/**
 * Util that working with jwt tokens
 * 
 * @autor Nikolay Osetrov
 * @since 0.1.4
 * @see   https://github.com/DarkSavant7/demo-market-app/blob/master/src/main/java/org/example/demomarketapp/util/JwtTokenUtil.java
 */
@Component
public class JwtTokenUtil {

	@Value("${jwt.secret}")
	private String secret;

	@Value("${jwt.expiration.minutes:120}")
	private long minutesToExpire;

	public String generateTokenFromUser(UserEntity user) {
		Map<String, Object> claims = new HashMap<>();
		var roles = user.getUserRoles()
				.stream()
				.map(
						r -> new SimpleGrantedAuthority(
								r.getName()
										.toString()
						)
				)
				.map(GrantedAuthority::getAuthority)
				.toList();
		claims.put("roles", roles);
		claims.put("some1", "some info");
		claims.put("some2", "some info # 2");
		claims.put("some list", List.of("one", "two", "three"));

		Date issuedDate = new Date();
		Date expired = new Date(issuedDate.getTime() + minutesToExpire * 1000 * 60);

		return Jwts.builder()
				.claims(claims)
				.subject(user.getEmail())
				.issuedAt(issuedDate)
				.expiration(expired)
				.signWith(SignatureAlgorithm.HS256, secret)
				.compact();
	}

	public String getUsernameFromToken(String token) {
		return getClaimFromToken(token, Claims::getSubject);
	}

	public List<String> getRolesFromToken(String token) {
		return getClaimFromToken(token, (Function<Claims, List<String>>) claims -> claims.get("roles", List.class));
	}

	private <T> T getClaimFromToken(String token, Function<Claims, T> claimsTFunction) {
		Claims claims = getAllClaimsFromToken(token);
		return claimsTFunction.apply(claims);
	}

	private Claims getAllClaimsFromToken(String token) {
		return Jwts.parser()
				.setSigningKey(secret)
				.build()
				.parseClaimsJws(token)
				.getBody();
	}
}
