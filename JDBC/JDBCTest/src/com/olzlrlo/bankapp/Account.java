package com.olzlrlo.bankapp;

import lombok.Getter;
import lombok.Setter;

public class Account {

	@Getter
	@Setter
	private String ano;

	@Getter
	@Setter
	private String owner;

	@Getter
	@Setter
	private int balance;
	
	public Account(String ano, String owner, int balance) {
		this.ano = ano;
		this.owner = owner;
		this.balance = balance;
	}
}
